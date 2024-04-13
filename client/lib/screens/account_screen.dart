import "package:flutter/material.dart";

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
      child: Text("Account screen"),
    );
  }
}
