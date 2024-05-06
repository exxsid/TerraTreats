import "dart:convert";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:terratreats/models/delivery_schedule.dart";
import "package:terratreats/utils/preferences.dart";

final baseUrl = dotenv.env['BASE_URL'];

Future<List<dynamic>> getDeliverySchedules() async {
  final uri = Uri.parse('$baseUrl/delivery-schedule?seller_id=${Token.getUserToken()}');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    
    return data
        .map((item) =>
            DeliveryScheduleModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception("Can't get delivery schedules.");
  }
}

Future<bool> addDeliverySchedule(String schedule) async {
  final uri = Uri.parse("$baseUrl/delivery-schedule");

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic>{
        "seller_id": Token.getUserToken(),
        "schedule": schedule,
      },
    ),
  );

  if (response.statusCode == 201) {
    return true;
  }
  else {
    throw Exception("Can't add delivery schedule");
  }
}


Future<bool> deleteDeliverySchedule(int deliveryId) async {
  final uri = Uri.parse("$baseUrl/delivery-schedule?delivery_id=$deliveryId");

  final response = await http.delete(uri);

  if (response.statusCode == 204) {
    return true;
  }
  else {
    throw Exception("Can't delete delivery schedule");
  }
}