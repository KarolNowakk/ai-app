import 'package:shared_preferences/shared_preferences.dart';

const String openAIKey = "open_ai_api_key";
const String apiKey = "api_key";

class Config {
  final Map<String, String> _config = {};

  Future<void> loadConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? openAIKeyValue = prefs.getString(openAIKey);
    String? apiKeyValue = prefs.getString(apiKey);

    _config[openAIKey] = openAIKeyValue ?? "";
    _config[apiKey] = apiKeyValue ?? "";

    if (_config[openAIKey] == "" || _config[apiKey] == "") {
      throw ConfigNotSetException();
    }
  }

  String getEntry(String entry) {
    return _config[entry] ?? "";
  }

  Future<void> saveConfig(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    _config[key] = value;
  }
}

class ConfigNotSetException implements Exception {
  @override
  String toString() => 'config is not set';
}
