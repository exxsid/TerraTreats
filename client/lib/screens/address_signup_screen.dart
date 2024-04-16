import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';
import 'package:terratreats/screens/otp.dart';

class AddressSignup extends ConsumerWidget {
  const AddressSignup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //title
              const AutoSizeText(
                "Address",
                maxLines: 1,
                minFontSize: 20,
                style: TextStyle(
                  fontSize: 50,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "* Required Fields",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Street",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "* Barangay",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "* Municipality/City",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "* Province",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "* Postal Code",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryButton(
                text: "Sign Up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const OTPScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
