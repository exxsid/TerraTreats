import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

class Texts extends ConsumerStatefulWidget {
  const Texts({super.key});

  @override
  _TextsState createState() => _TextsState();
}

class _TextsState extends ConsumerState<Texts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Center(
            child: Column(
              children: [
                Text(ref.watch(testNotifierProvider).email),
                ElevatedButton(
                  onPressed: () {
                    ref.read(testNotifierProvider.notifier).updateEmai("sampo");
                  },
                  child: Text("Press Me"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Test extends ChangeNotifier {
  String email = "";

  void printEmail() {
    print(email);
    notifyListeners();
  }

  void updateEmai(String email) {
    this.email = email;
    notifyListeners();
  }
}

final testNotifierProvider = ChangeNotifierProvider((ref) => Test());
