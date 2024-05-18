import "package:terratreats/utils/preferences.dart";
import 'package:web_socket_channel/web_socket_channel.dart';
import "dart:convert";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

final baseUrl = dotenv.env['BASE_URL'];

final channel = WebSocketChannel.connect(
  Uri.parse("$baseUrl/connect?id=${Token.getUserToken()}"),
);

Future<List<Map<String, dynamic>>> getChats() async {
  final uri = Uri.parse("$baseUrl/chat/messages?id=${Token.getUserToken()}");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .whereType<Map<String, dynamic>>()
        .cast<Map<String, dynamic>>()
        .toList();
  } else {
    throw Exception("Can't get messages");
  }
}

Future<List<Map<String, dynamic>>> getChatHistory(
    {required String chatId}) async {
  final uri = Uri.parse("$baseUrl/chat/history?chat_id=$chatId");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<Map<String, dynamic>>;
  } else {
    throw Exception("Can't get chat");
  }
}

Future<void> sendMessage(
  int to,
  String message,
  String chatId,
) async {
  final uri = Uri.parse("$baseUrl/chat/send");

  final response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(
      <String, dynamic>{
        "chat_id": chatId,
        "sender_id": Token.getUserToken(),
        "recipient_id": to,
        "message": message,
      },
    ),
  );

  if (response.statusCode != 200) {
    throw Exception("Can't send message");
  }
}
