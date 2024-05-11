import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/my_product_model.dart";
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

Future<bool> updateMyProduct({required MyProductModel product}) async {
  final uri = Uri.parse("$baseUrl/my-products");

  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      "product_id": product.productId,
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "stock": product.stock,
      "unit": product.unit,
      "image": product.image,
      "category": product.category,
      "shipping_fee": product.shippingFee,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Can't update product");
  }
}
