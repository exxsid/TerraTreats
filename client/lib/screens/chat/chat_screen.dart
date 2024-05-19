import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:terratreats/riverpod/chat_notifier.dart';
import 'package:terratreats/services/chat_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/utils/preferences.dart';
import 'package:terratreats/widgets/appbar.dart';
import 'package:terratreats/widgets/loading_indacators.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: MyAppBar.customAppBar(
        title: ref.watch(chatChangeNotifierProvider).recipient,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.highlight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: FutureBuilder(
                    future: getChatHistory(
                        chatId: ref.watch(chatChangeNotifierProvider).chatId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingIndicator.circularLoader();
                      }

                      if (snapshot.hasError) {
                        return Container(
                          child: const Center(
                            child: Text("Can't load messages."),
                          ),
                        );
                      }

                      if (snapshot.data!.isEmpty) {
                        return Container(
                          child: const Center(
                            child: Text("No messages."),
                          ),
                        );
                      }

                      final chats = snapshot.data!;

                      return ListView.builder(
                        reverse: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];

                          bool isMyChat =
                              chat['sender_id'] == Token.getUserToken();

                          DateTime originalDateTime =
                              DateTime.parse(chat['timestamp']);

                          String formattedDateTime =
                              DateFormat("MMM d, yyyy hh:mm a")
                                  .format(originalDateTime);
                          return bubbleChat(
                            isMyChat,
                            context,
                            chat,
                            formattedDateTime,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              inputMessageContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Row bubbleChat(bool isMyChat, BuildContext context, Map<String, dynamic> chat,
      String formattedDateTime) {
    const double bubbleChatRadius = 12;
    return Row(
      mainAxisAlignment:
          isMyChat ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: isMyChat ? AppTheme.secondary : Colors.white,
            borderRadius: isMyChat
                ? const BorderRadius.only(
                    topLeft: Radius.circular(bubbleChatRadius),
                    topRight: Radius.circular(bubbleChatRadius),
                    bottomLeft: Radius.circular(bubbleChatRadius),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(bubbleChatRadius),
                    topRight: Radius.circular(bubbleChatRadius),
                    bottomRight: Radius.circular(bubbleChatRadius),
                  ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(176, 190, 197, 1),
                spreadRadius: 0.5,
                blurRadius: 2,
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat['message'],
                softWrap: true,
              ),
              Text(
                formattedDateTime,
                softWrap: true,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container inputMessageContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.greenAccent[100],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                ref
                    .read(messageChangeNotifierProvider.notifier)
                    .updateMessage(value);
              },
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: ref.watch(messageChangeNotifierProvider).message.isEmpty
                ? null
                : () {},
            icon: Icon(FeatherIcons.send),
            disabledColor: Colors.blueGrey,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class MessageChangeNotifier extends ChangeNotifier {
  String message = "";

  void updateMessage(String m) {
    message = m;
    notifyListeners();
  }
}

final messageChangeNotifierProvider =
    ChangeNotifierProvider((ref) => MessageChangeNotifier());
