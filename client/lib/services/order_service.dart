import "package:terratreats/models/cart_model.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/order_model.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<bool> addToOrder(Order order) async {
  final uri = Uri.parse("$baseUrl/order");

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic>{
        "user_id": order.userId,
        "order_status": order.orderStatus.name,
        "shipping_fee": order.shippingFee,
        "product_id": order.productId,
        "quantity": order.quantity,
        "order_size": order.orderSize,
      },
    ),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception("Failed to add to cart");
  }
}
