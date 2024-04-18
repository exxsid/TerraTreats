import 'package:terratreats/riverpod/categorycard_notifier.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;

final baseUrl = dotenv.env["BASE_URL"];

Future<List<dynamic>> getCategory() async {
  final uri = Uri.parse("$baseUrl/category");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => CategoryCardItem.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get categories.");
  }
}
