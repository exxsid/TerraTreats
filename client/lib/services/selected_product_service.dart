import "package:terratreats/models/product_model.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<Product> getSelectedProduct(int id) async {
  final uri = Uri.parse("$baseUrl/product?id=$id");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Product(
      productId: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      stock: json['stock'] as int,
      unit: json['unit'] as String,
      imgUrl: json['imgUrl'] as String,
      rating: json['rating'] as double,
      category: json['category'] as String,
      seller: json['seller'] as String,
    );
  } else {
    throw Exception("Failed to get recommended products.");
  }
}
