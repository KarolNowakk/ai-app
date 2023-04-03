import 'dart:convert';
import 'package:http/http.dart' as http;

const String url = "https://api.openai.com/v1/completions";
const String apiKey = "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";

Future<String> sendOpenAIRequest(Map<String, dynamic> body) async {
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    },
    body: jsonEncode(body),
  );

  print(response);

  if (response.statusCode == 200) {
    return response.body;
  }

  throw APIRequestErrorException(response.body);
}


class APIRequestErrorException implements Exception {
  String message;

  APIRequestErrorException(this.message);

  String errorMessage() {
    return "Error: $message";
  }
}