import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends ChangeNotifier {
  String recipient = "";
  String chatId = "";
  int recipientId = 0;

  void updateRecipient(String r) {
    recipient = r;
    notifyListeners();
  }

  void updateChatId(String id) {
    chatId = id;
    notifyListeners();
  }

  void updateRecipientId(int id) {
    recipientId = id;
    notifyListeners();
  }
}

final chatChangeNotifierProvider =
    ChangeNotifierProvider((ref) => ChatNotifier());

class ChatHistoryNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> chatHistory = [];

  void initializedChatHistory(List<Map<String, dynamic>> chatHistory) {
    this.chatHistory = chatHistory;
    notifyListeners();
  }

  void appendChat(Map<String, dynamic> chat) {
    chatHistory.add(chat);
    notifyListeners();
  }
}

final chatHistoryNotifierProvider =
    ChangeNotifierProvider((ref) => ChatHistoryNotifier());
