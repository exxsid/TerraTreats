import "package:flutter_dotenv/flutter_dotenv.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:terratreats/models/reviews_model.dart";

final baseUrl = dotenv.env["BASE_URL"];

Future<List<dynamic>> getReviews(int productId) async {
  final uri = Uri.parse("$baseUrl/reviews?product_id=$productId");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) {
      return data;
    }
    return data
        .map((review) => ReviewModel.getReviews(review as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception("Can't get reviews");
  }
}
