class LoginModel {
  final String email;
  final String password;

  const LoginModel({
    required this.email,
    required this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'password': String password,
      } =>
        LoginModel(
          email: email,
          password: password,
        ),
      _ => throw const FormatException('Failed to load LoginService.'),
    };
  }
}
