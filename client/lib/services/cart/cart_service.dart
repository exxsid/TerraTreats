import "package:terratreats/models/cart_model.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;

final baseUrl = dotenv.env["BASE_URL"];

Future<List<dynamic>> getCarts(int userId) async {
  final uri = Uri.parse("$baseUrl/cart?user_id=$userId");

  final response = await http.get(uri);

  print(response.statusCode == 200);

  if (response.statusCode == 200) {
    print("fuck man");
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Cart.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load cart.");
  }
}
