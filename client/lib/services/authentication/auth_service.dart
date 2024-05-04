import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/models/auth_models.dart";
import "package:terratreats/utils/preferences.dart";
import "package:shared_preferences/shared_preferences.dart";

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
      final userId = response.headers['set-cookie']
          ?.split(";")[0]
          .trim()
          .split("=")[1]
          .trim();
      final content = jsonDecode(response.body);
      await Token.setUserToken(int.parse(userId!));
      await Token.setEmailToken(content['email']);
      await Token.setPasswordToken(content['password']);
      await Token.setFirstNameToken(content['first_name']);
      await Token.setLastNameToken(content['last_name']);
      await Token.setPhonenumberToken(content['phonenumber']);
      await Token.setIsSellerToken(content['is_seller']);
      await Token.setStreetToken(content['street']);
      await Token.setBarangayToken(content['barangay']);
      await Token.setCityToken(content['city']);
      await Token.setProvinceToken(content['province']);
      await Token.setPostalCodeToken(content['postal_code']);
      await Token.setIsVerifiedToken(content['is_verified']);

      return LoginModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to login.");
    }
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phonenumber,
    String? street,
    required String barangay,
    required String city,
    required String province,
    required String postalCode,
  }) async {
    final uri = Uri.parse("$baseUrl/signup");

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "phonenumber": phonenumber,
        "street": street!,
        "barangay": barangay,
        "city": city,
        "province": province,
        "postal_code": postalCode
      }),
    );

    if (response.statusCode == 400 || response.statusCode == 406) {
      throw Exception("Failed to signup.");
    }

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Failed to signup.");
    }
  }
}
