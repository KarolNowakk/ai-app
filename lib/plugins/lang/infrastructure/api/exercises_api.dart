import 'dart:convert';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseApiClient {
  final Config _config = KiwiContainer().resolve<Config>();
  final String _baseUrl;
  final String _token;

  ExerciseApiClient()
      : _baseUrl = dotenv.env['API_BASE_URL']!,
       _token = "";
       // _token = "";

  // Helper method to get the headers for the requests
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_config.getEntry(apiKey)}',
    };
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exercises/all'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> create(Map<String, dynamic> exerciseData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/exercises/create'),
      headers: _getHeaders(),
      body: json.encode(exerciseData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> update(Map<String, dynamic> exerciseData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/exercises/update'),
      headers: _getHeaders(),
      body: json.encode(exerciseData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> delete(int exerciseId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/exercises/delete/$exerciseId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
