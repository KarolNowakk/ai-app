import 'package:app2/plugins/lang/domain/exercise_structure.dart';

abstract class ExerciseRepoInterface {
  Future<List<ExerciseStructure>> getAllExercises();
  void deleteExercise(ExerciseStructure exercise);
  void saveOrUpdateExercise(ExerciseStructure exercise);
}