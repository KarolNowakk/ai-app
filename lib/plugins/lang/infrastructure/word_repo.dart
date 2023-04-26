import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/lang/screens/chat/rate_modal.dart';
import 'package:app2/plugins/lang/screens/chat/save_word_modal.dart';
import 'package:kiwi/kiwi.dart';

class WordRepo implements WordsRepoPromptInterface, WordRepoUpdateInterface, CreateWordRepoInterface{
  final WordApiClient _api = KiwiContainer().resolve<WordApiClient>();
  final CurrentExerciseSettingsInterface _exe = KiwiContainer().resolve<CurrentExerciseSettingsInterface>();

  @override
  Future<List<WordData>> getAllWords() async {
    ExerciseStructure? currentExe = await _exe.getExerciseSettings();
    List<Map<String, dynamic>> rawList = await _api.getAllWords(currentExe != null ? currentExe!.lang : "nope");
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