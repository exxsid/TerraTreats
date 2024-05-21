import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  final _channel = WebSocketChannel.connect(
    Uri.parse("$websocketUrl/connect?id=${Token.getUserToken()}"),
  );

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
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
              StreamBuilder<dynamic>(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data =
                        jsonDecode(snapshot.data) as Map<String, dynamic>;
                    ref
                        .read(chatHistoryNotifierProvider.notifier)
                        .appendChat(data);
                  }
                  // Return your chat thread widget here
                  return chatThread();
                },
              ),
              inputMessageContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded chatThread() {
    return Expanded(
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
            ref
                .read(chatHistoryNotifierProvider.notifier)
                .initializedChatHistory(snapshot.data!);

            return ListView.builder(
              reverse: true,
              itemCount:
                  ref.watch(chatHistoryNotifierProvider).chatHistory.length,
              itemBuilder: (context, index) {
                final chat =
                    ref.watch(chatHistoryNotifierProvider).chatHistory[index];

                bool isMyChat = chat['sender_id'] == Token.getUserToken();

                DateTime originalDateTime = DateTime.parse(chat['timestamp']);

                String formattedDateTime =
                    DateFormat("MMM d, yyyy hh:mm a").format(originalDateTime);
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
                : () {
                    _sendMessage();
                  },
            icon: Icon(FeatherIcons.send),
            disabledColor: Colors.blueGrey,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = ref.watch(messageChangeNotifierProvider).message;
    Future(() => ref.read(messageChangeNotifierProvider.notifier).message = "");

    sendMessage(
      ref.watch(chatChangeNotifierProvider).recipientId,
      message,
      ref.watch(chatChangeNotifierProvider).chatId,
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
