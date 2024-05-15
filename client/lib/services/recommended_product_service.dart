import "package:terratreats/models/product_model.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<List<Product>> getRecommendedProducts() async {
  final uri = Uri.parse("$baseUrl/reco-product");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get recommended products.");
  }
}
