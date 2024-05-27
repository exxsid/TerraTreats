import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditAccountInfoNotifier extends ChangeNotifier {
  String info = "";

  void updateInfo(String i) {
    info = i;
    notifyListeners();
  }
}

final editAccountInfoNotifierProvider = ChangeNotifierProvider(
  (ref) => EditAccountInfoNotifier(),
);
