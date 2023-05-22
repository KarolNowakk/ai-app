import 'package:app2/plugins/lang/application/current_ecercise_repo.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:kiwi/kiwi.dart';

class WordRepo implements WordsRepoInterface{
  final WordApiClient _api = KiwiContainer().resolve<WordApiClient>();
  final CurrentExerciseRepoInterface _exe = KiwiContainer().resolve<CurrentExerciseRepoInterface>();

  @override
  Future<List<WordData>> getAllWords() async {
    ExerciseStructure? currentExe = await _exe.getExerciseSettings();
    List<Map<String, dynamic>> rawList = await _api.getWordsForSRS(currentExe != null ? currentExe!.lang : "nope");

    print(rawList);

    List<WordData> wordsList = rawList.map((exercise) => WordData.fromJson(exercise)).toList();

    return wordsList;
  }

  @override
  Future<List<WordData>> getByIds(List<String> listIds) async {
    List<Map<String, dynamic>> rawList = await _api.getWordsByIds(listIds);
    List<WordData> wordsList = rawList.map((exercise) => WordData.fromJson(exercise)).toList();

    return wordsList;
  }

  @override
  Future<void> addWordDataToList(WordData word) async {
    Map<String, dynamic> wordData = word.toJson();
    _api.createWord(wordData);
  }

  @override
  Future<void> updateWordDataInList(WordData updatedWordData) async {
      Map<String, dynamic> wordData = updatedWordData.toJson();
      _api.updateWord(wordData);
  }
}