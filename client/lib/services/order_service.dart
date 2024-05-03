import "package:terratreats/models/cart_model.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/order_model.dart";
import "package:terratreats/models/parcel_model.dart";

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


Future<List<Parcel>> getToPayParcel(int userId) async{
  final uri = Uri.parse('$baseUrl/to-pay?user_id=$userId');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Parcel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get recommended products.");
  }
}

Future<List<Parcel>> getToShipParcel(int userId) async{
  final uri = Uri.parse('$baseUrl/to-ship?user_id=$userId');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Parcel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get recommended products.");
  }
}

Future<List<Parcel>> getToDeliverParcel(int userId) async{
  final uri = Uri.parse('$baseUrl/to-deliver?user_id=$userId');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Parcel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get recommended products.");
  }
}

Future<List<Parcel>> getToReviewParcel(int userId) async{
  final uri = Uri.parse('$baseUrl/to-review?user_id=$userId');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Parcel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to get recommended products.");
  }
}