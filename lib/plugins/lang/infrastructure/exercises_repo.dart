import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/exercises_api.dart';
import 'package:app2/plugins/lang/screens/exercise/create.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseRepo implements ExercisesRepoInterface, ExerciseSaverRepoInterface {
  final ExerciseApiClient _api = KiwiContainer().resolve<ExerciseApiClient>();

  @override
  Future<List<ExerciseStructure>> getAllExercises() async {
    List<Map<String, dynamic>> rawList = await _api.getAll();

    List<ExerciseStructure> exerciseList = rawList.map((exercise) => ExerciseStructure.fromJson(exercise)).toList();

    return exerciseList;
  }

  @override
  void deleteExercise(ExerciseStructure exercise) {
      _api.delete(exercise.id);
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

//
// [
// {
// "role": "system",
// "content": "Act as german teacher, give me a sentence in German on B1 level. Ask me to translate this message. After you recieve my translation provide me a feedback, point out mistakes and give me alternative translation."
// },
// {
// "role": "assistant",
// "content": "Sure, here's a sentence in German at a B2 level:\n\"Ich bin gestern Abend ins Kino gegangen.\"\nPlease provide a translation into Polish, and I'll give you feedback on any mistakes."
// },
// {
// "role": "user",
// "content": "\"Wczoraj wieczorem poszedlem obejrzec film.\""
// },
// {
// "role": "assistant",
// "content": "Dobrze! Twoje tłumaczenie brzmi bardzo dobrze i jest zrozumiałe. Jednakże, jedna poprawka: w zdaniu chodzi o pojscie do kina a nie o pojscie na film. Więc poprawne tłumaczenie brzmi: \"Ich bin gestern Abend ins Kino gegangen.\""
// },
// {
// "role": "user",
// "content": "Prosze kontynuuj z nastepnym zdaniem."
// }
// ]