import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/authentication.dart';

import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';
import 'package:terratreats/screens/address_signup_screen.dart';

// gender
final List<String> _genders = <String>["Male", "Female"];

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool _passwordVisible = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? _emailValidate(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }

    if (!EmailValidator.validate(value)) {
      return "Wrong email format.";
    }

    return null;
  }

  String _genderValue = _genders.first;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
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
                                ref
                                    .read(signupNotifierProvider.notifier)
                                    .firstName = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
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
                                ref
                                    .read(signupNotifierProvider.notifier)
                                    .lastName = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: _emailValidate,
                        onChanged: (value) {
                          ref.read(signupNotifierProvider.notifier).email =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone Number",
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
                          ref
                              .read(signupNotifierProvider.notifier)
                              .phoneNumber = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        value: _genderValue,
                        onChanged: (value) {
                          setState(() {
                            _genderValue = value!;
                          });
                          ref.read(signupNotifierProvider.notifier).gender =
                              value!;
                        },
                        items: _genders
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
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
                          ref.read(signupNotifierProvider.notifier).password =
                              value;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      PrimaryButton(
                        text: "Next",
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const AddressSignup(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // navigate to login screen
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Have an account? Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
