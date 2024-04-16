import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

import 'package:terratreats/screens/bottom_navbar.dart';
import 'package:terratreats/screens/signup.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';
import 'package:terratreats/services/authentication/auth_service.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool _passwordVisible = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = ref.watch(loginNotifierProvider).email;
    final password = ref.watch(loginNotifierProvider).password;
    final token = await AuthService().login(email, password);
    print(token);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
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
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                onChanged: (value) {
                                  ref
                                      .read(loginNotifierProvider.notifier)
                                      .email = value;
                                },
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field is required";
                                  }
                                  if (!EmailValidator.validate(value)) {
                                    return "Wrong email format";
                                  }

                                  return null;
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
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
                                ref
                                    .read(loginNotifierProvider.notifier)
                                    .password = value;
                              },
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is required.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            PrimaryButton(
                              text: "Login",
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _login();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        print("login pressed");
                                        return const BottomNavBar();
                                      },
                                    ),
                                  );
                                } on Exception catch (ex) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return failedLoginAlertDialog(
                                            ex.toString());
                                      });
                                }
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
      ),
    );
  }

  AlertDialog failedLoginAlertDialog(String msg) {
    return AlertDialog(
      title: const Text("Faild Login"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(msg),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
