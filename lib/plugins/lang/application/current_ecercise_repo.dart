import 'package:app2/plugins/lang/domain/exercise_structure.dart';

abstract class CurrentExerciseRepoInterface {
  Future<void> saveExerciseSettings(ExerciseStructure exercise);
  Future<ExerciseStructure?> getExerciseSettings();
}