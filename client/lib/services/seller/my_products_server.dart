import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/product_model.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<List<Product>> getMyProducts() async {
  final uri =
      Uri.parse("$baseUrl/my-products?seller_id=${Token.getUserToken()}");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map(
          (product) => Product.fromJson(product as Map<String, dynamic>),
        )
        .toList();
  } else {
    throw Exception("Can't get my products");
  }
}
