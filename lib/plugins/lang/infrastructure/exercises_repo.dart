import 'dart:developer';

import 'package:app2/plugins/lang/application/exercise_repo.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/exercises_api.dart';
import 'package:app2/plugins/lang/screens/exercise/create.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseRepo implements ExerciseRepoInterface {
  final ExerciseApiClient _api = KiwiContainer().resolve<ExerciseApiClient>();

  @override
  Future<List<ExerciseStructure>> getAllExercises() async {
    List<Map<String, dynamic>> rawList = await _api.getAll();

    List<ExerciseStructure> exerciseList = rawList.map((exercise) => ExerciseStructure.fromJson(exercise)).toList();

    return exerciseList;
  }

  @override
  void deleteExercise(ExerciseStructure exercise) {
      _api.delete(exercise.id!);
  }

  @override
  void saveOrUpdateExercise(ExerciseStructure exercise) {
    if (exercise.id != "") {
      Map<String, dynamic> exerciseData = exercise.toJson();
      _api.update(exerciseData);
      return;
    }
    Map<String, dynamic> exerciseData = exercise.toJson();
    _api.create(exerciseData);
  }
}