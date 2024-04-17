import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';
import 'package:terratreats/screens/otp.dart';
import 'package:terratreats/riverpod/authentication.dart';

class AddressSignup extends ConsumerStatefulWidget {
  const AddressSignup({super.key});

  @override
  ConsumerState<AddressSignup> createState() => _AddressSignupState();
}

class _AddressSignupState extends ConsumerState<AddressSignup> {
  final _formKey = GlobalKey<FormState>();

  String? _validateInput(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Street",
                  ),
                  onChanged: (value) {
                    ref.read(signupNotifierProvider.notifier).street = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Barangay",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: _validateInput,
                  onChanged: (value) {
                    ref.read(signupNotifierProvider.notifier).barangay = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Municipality/City",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: _validateInput,
                  onChanged: (value) {
                    ref.read(signupNotifierProvider.notifier).city = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Province",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: _validateInput,
                  onChanged: (value) {
                    ref.read(signupNotifierProvider.notifier).province = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postal Code",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: _validateInput,
                  onChanged: (value) {
                    ref.read(signupNotifierProvider.notifier).postalCode =
                        value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                  text: "Sign Up",
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

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
      ),
    );
  }
}
