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

class SignUpNotifier extends ChangeNotifier {
  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String gender = "";
  String password = "";
}

final loginNotifierProvider = ChangeNotifierProvider((ref) {
  return LoginNotifier();
});

final signupNotifierProvider = ChangeNotifierProvider((ref) {
  return SignUpNotifier();
});
