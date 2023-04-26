import 'dart:convert';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kiwi/kiwi.dart';

class WordApiClient {
  final Config _config = KiwiContainer().resolve<Config>();
  final String _baseUrl;

  WordApiClient()
      : _baseUrl = dotenv.env['API_BASE_URL']!;

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_config.getEntry(apiKey)}',
    };
  }

  Future<List<Map<String, dynamic>>> getAllWords(String lang) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/words/all-by-lang?lang=$lang'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load words: ${response.body}');
    }

    final List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> createWord(Map<String, dynamic> word) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/words/create'),
      headers: _getHeaders(),
      body: json.encode(word),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create word: ${response.body}');
    }
  }

  Future<void> updateWord(Map<String, dynamic> word) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/words/update'),
      headers: _getHeaders(),
      body: json.encode(word),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update word: ${response.body}');
    }
  }

  Future<void> deleteWord(int wordId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/words/delete/$wordId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete word: ${response.body}');
    }
  }
}
