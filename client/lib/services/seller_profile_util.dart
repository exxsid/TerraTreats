import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/models/product_model.dart";
import "package:terratreats/models/seller_profile_model.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<SellerProfileModel> getSellerProfile(int sellerId) async {
  final uri = Uri.parse("$baseUrl/seller-profile?seller_id=$sellerId");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = SellerProfileModel.fromJson(jsonDecode(response.body));
    print("ddddaattaa $data");
    return data;
  } else {
    throw Exception("Can't get seller profile");
  }
}

Future<List<Product>> getSellerProducts(int sellerId) async {
  final uri = Uri.parse("$baseUrl/seller-profile/products?seller_id=$sellerId");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception("Can't get seller profile");
  }
}
