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

Future<bool> deleteCart(String cartId) async {
  final uri = Uri.parse("$baseUrl/cart?id=$cartId");

  final response = await http.delete(uri);

  if (response.statusCode == 204) {
    return true;
  } else {
    throw Exception("Failed to delete cart.");
  }
}

Future<bool> addToCart(int productId, int userId) async {
  final uri = Uri.parse("$baseUrl/cart");

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic>{
        'user_id': userId,
        'product_id': productId,
      },
    ),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception("Failed to add to cart");
  }
}
