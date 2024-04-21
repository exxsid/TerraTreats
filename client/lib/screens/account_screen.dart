import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";

import "package:terratreats/screens/login.dart";
import "package:terratreats/utils/token_util.dart";

class Account extends ConsumerStatefulWidget {
  const Account({super.key});

  @override
  ConsumerState<Account> createState() => _AccountState();
}

// TODO: create a separate account screen for seller
class _AccountState extends ConsumerState<Account> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return Consumer(builder: (context, ref, child) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('This is a demo alert dialog.'),
                          Text('Would you like to approve of this message?'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          ref
                              .read(navigationNotifierProvider.notifier)
                              .updateNavigationIndex(0);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const Login();
                            }),
                            ModalRoute.withName("/"),
                          );
                        },
                      ),
                      TextButton(
                        child: const Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
              }),
        ),
      ),
    );
  }
}
