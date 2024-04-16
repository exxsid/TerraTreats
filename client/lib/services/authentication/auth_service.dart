import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/models/auth_models.dart";

class AuthService {
  final baseUrl = dotenv.env["BASE_URL"];

  Future<LoginModel> login(String email, String password) async {
    final uri = Uri.parse("$baseUrl/login");

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 404) {
      throw Exception("Wrong email or password");
    }

    if (response.statusCode == 201) {
      return LoginModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to login.");
    }
  }
}
