import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CurrentExerciseRepo implements CurrentExerciseSettingsInterface, CurrentExerciseSaverInterface {
  final String _key = "current_exercise";

  @override
  Future<void> saveExerciseSettings(ExerciseStructure exercise) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(exercise.toJson());
    await prefs.setString(_key, jsonString);
  }

  @override
  Future<ExerciseStructure?> getExerciseSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ExerciseStructure.fromJson(json);
  }
}