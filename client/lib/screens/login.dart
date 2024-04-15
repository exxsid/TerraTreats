import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/authentication.dart';

import 'package:terratreats/screens/bottom_navbar.dart';
import 'package:terratreats/screens/signup.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool _passwordVisible = true;

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // login form
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        controller: _emailController,
                        onChanged: (value) {
                          ref.read(loginNotifierProvider.notifier).email =
                              value;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
                      onChanged: (value) {
                        ref.read(loginNotifierProvider.notifier).password =
                            value;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    PrimaryButton(
                      text: "Login",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              print("login pressed");
                              return const BottomNavBar();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // navigate to signup screen
              Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: Text("Don't have an accout? Sign up"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
