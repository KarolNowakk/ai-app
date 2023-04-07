import 'dart:convert';
import 'package:http/http.dart' as http;

const String url = "https://api.openai.com/v1/chat/completions";
const String apiKey = "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";

Future<String> sendOpenAIRequest(Map<String, dynamic> body) async {
  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $apiKey'
    },
    body: jsonEncode(body),
  );

  final codeUnits = response.body.codeUnits;

  print(Utf8Decoder().convert(codeUnits));
  print(response.statusCode);

  if (response.statusCode == 200) {
    return Utf8Decoder().convert(codeUnits);
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