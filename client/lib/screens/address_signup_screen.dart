import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:terratreats/screens/login.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';
import 'package:terratreats/screens/otp.dart';
import 'package:terratreats/riverpod/authentication.dart';
import 'package:terratreats/services/authentication/auth_service.dart';

class AddressSignup extends ConsumerStatefulWidget {
  const AddressSignup({super.key});

  @override
  ConsumerState<AddressSignup> createState() => _AddressSignupState();
}

class _AddressSignupState extends ConsumerState<AddressSignup> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String? _validateInput(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  Future<void> _signup() async {
    final firstName = ref.watch(signupNotifierProvider).firstName;
    final lastName = ref.watch(signupNotifierProvider).lastName;
    final email = ref.watch(signupNotifierProvider).email;
    final phonenumber = ref.watch(signupNotifierProvider).phoneNumber;
    final password = ref.watch(signupNotifierProvider).password;
    final street = ref.watch(signupNotifierProvider).street;
    final barangay = ref.watch(signupNotifierProvider).barangay;
    final city = ref.watch(signupNotifierProvider).city;
    final province = ref.watch(signupNotifierProvider).province;
    final postalCode = ref.watch(signupNotifierProvider).postalCode;

    final token = await AuthService().signup(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phonenumber: phonenumber,
        street: street,
        barangay: barangay,
        city: city,
        province: province,
        postalCode: postalCode);
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
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: "Street",
                        ),
                        onChanged: (value) {
                          ref.read(signupNotifierProvider.notifier).street =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          ref.read(signupNotifierProvider.notifier).barangay =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          ref.read(signupNotifierProvider.notifier).city =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                          ref.read(signupNotifierProvider.notifier).province =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await _signup();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }),
                              ModalRoute.withName("/"),
                            );
                          } on Exception catch (ex) {
                            print(ex);
                            setState(() {
                              _isLoading = false;
                            });
                          }

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (builder) => const OTPScreen(),
                          //   ),
                          // );
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
