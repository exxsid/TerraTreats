import "package:terratreats/models/product_model.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/services/authentication/auth_service.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<void> sellInTerratreats() async {
  final uri = Uri.parse(
      "$baseUrl/verify-seller-application?user_id=${Token.getUserToken()}");

  final response = await http.post(uri);

  if (response.statusCode != 200) {
    throw Exception("Can't verify seller application");
  }

  await AuthService().login(Token.getEmailToken()!, Token.getPasswordToken()!);
}
