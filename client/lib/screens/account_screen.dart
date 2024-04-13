import "package:flutter/material.dart";
import "package:terratreats/screens/login.dart";

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

// TODO: create a separate account screen for seller
class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
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
                      onPressed: () => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Login();
                          }),
                          ModalRoute.withName("/"),
                        ),
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
              }),
        ),
      ),
    );
  }
}
