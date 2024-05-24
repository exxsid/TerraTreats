import 'package:terratreats/models/featured_product_model.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<FeaturedProduct> getFeaturedProduct() async {
  final uri = Uri.parse(
      "$baseUrl/featured-product?zip_code=${Token.getPostalCodeToken()}");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return FeaturedProduct.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to get featured products.");
  }
}
