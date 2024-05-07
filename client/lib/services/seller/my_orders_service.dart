import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/my_orders_model.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<List<MyOrdersModel>> getMyOrders() async {
  final uri = Uri.parse("$baseUrl/my-orders?seller_id=${Token.getUserToken()}");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => MyOrdersModel.fromJson(item)).toList();
  }
  else {
    throw Exception("Can't get my orders");
  }
}

Future<bool> updateMyOrderStatus(int orderId, String newStatus) async {
  final uri = Uri.parse("$baseUrl/my-orders?order_id=$orderId&new_status=$newStatus");

  final response = await http.put(uri);

  if (response.statusCode == 201) {
    return true;
  }
  else {
    throw Exception("Can't update order status");
  }
}