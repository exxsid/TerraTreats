import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends ChangeNotifier {
  String recipient = "";
  String chatId = "";

  void updateRecipient(String r) {
    recipient = r;
    notifyListeners();
  }

  void updateChatId(String id) {
    chatId = id;
    notifyListeners();
  }
}

final chatChangeNotifierProvider =
    ChangeNotifierProvider((ref) => ChatNotifier());
