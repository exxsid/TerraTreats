import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:terratreats/riverpod/chat_notifier.dart";
import "package:terratreats/screens/chat/chat_screen.dart";

import "package:terratreats/services/chat_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/widgets/loading_indacators.dart";

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: RefreshIndicator(
        child: messagesListView(),
        onRefresh: () async {
          setState(() {});
        },
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> messagesListView() {
    return FutureBuilder(
      future: getChats(),
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

        final messages = snapshot.data!;

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Consumer(
              builder: (context, ref, child) {
                return InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 2,
                          spreadRadius: 0.5,
                        ),
                      ],
                      color: AppTheme.highlight,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blueAccent,
                          ),
                          child: Icon(
                            Ionicons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          message['recipient'],
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(chatChangeNotifierProvider.notifier)
                        .updateRecipient(message['recipient']);
                    ref
                        .read(chatChangeNotifierProvider.notifier)
                        .updateChatId(message['id']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatScreen();
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
