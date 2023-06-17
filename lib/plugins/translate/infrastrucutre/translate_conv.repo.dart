import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TranslateConvRepo {
  static const String translatorConv = "translator_conv";
  static const String miniTranslatorConv = "mini_translator_conv";

  Future<void> save(String key, AIConversation exercise) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(exercise.toJson());
    await prefs.setString(key, jsonString);
  }

  Future<AIConversation?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AIConversation.fromJson(json);
  }
}
