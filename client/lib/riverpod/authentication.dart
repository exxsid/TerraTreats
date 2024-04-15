import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginNotifier extends ChangeNotifier {
  String email = "";
  String password = "";

  void login() {
    print(email);
    print(password);
  }
}

final loginNotifierProvider = ChangeNotifierProvider((ref) {
  return LoginNotifier();
});
