import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:terratreats/utils/app_theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Address",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Gender",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
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
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: AppTheme.highlight,
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
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
    );
  }
}
