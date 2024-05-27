import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<void> editName(String newFirstname, String newLastname) async {
  final uri = Uri.parse("$baseUrl/name");

  final response = await http.put(
    uri,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(
      <String, dynamic>{
        "user_id": Token.getUserToken(),
        "first_name": newFirstname,
        "last_name": newLastname,
      },
    ),
  );

  if (response.statusCode != 200) {
    throw Exception("Can't edit name");
  }

  await Token.setFirstNameToken(newFirstname);
  await Token.setLastNameToken(newLastname);
}

Future<void> editPassword(String password) async {
  final uri = Uri.parse(
      "$baseUrl/password?user_id=${Token.getUserToken()}&password=$password");

  final response = await http.put(uri);

  if (response.statusCode != 200) {
    throw Exception("Can't edit password");
  }

  await Token.setPasswordToken(password);
}

Future<void> editPhonenumber(String phonenumber) async {
  final uri = Uri.parse(
      "$baseUrl/phonenumber?user_id=${Token.getUserToken()}&phonenumber=$phonenumber");

  final response = await http.put(uri);

  if (response.statusCode != 200) {
    throw Exception("Can't edit phonenumber");
  }

  await Token.setPhonenumberToken(phonenumber);
}

Future<void> editEmail(String email) async {
  final uri =
      Uri.parse("$baseUrl/email?user_id=${Token.getUserToken()}&email=$email");

  final response = await http.put(uri);

  if (response.statusCode != 200) {
    throw Exception("Can't edit email");
  }

  await Token.setEmailToken(email);
}
