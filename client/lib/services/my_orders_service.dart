import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/models/my_product_model.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<bool> updateMyProduct({required MyProductModel product}) async {
  final uri = Uri.parse("/my-products");

  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      "product_ic": product.productId,
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
