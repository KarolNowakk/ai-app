import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:kiwi/kiwi.dart';

class WordsRepo implements WordsRepoInterface{
  final WordApiClient _api = KiwiContainer().resolve<WordApiClient>();

  @override
  Future<List<WordData>> getAllWords(String lang) async {
    List<Map<String, dynamic>> rawList = await _api.getAllWords(lang);
    List<WordData> wordsList = rawList.map((exercise) => WordData.fromJson(exercise)).toList();

    return wordsList;
  }

  @override
  Future<void> updateWord(WordData updatedWordData) async {
    Map<String, dynamic> wordData = updatedWordData.toJson();
    _api.updateWord(wordData);
  }

  Future<void> addWordDataToList(WordData word) async {
    Map<String, dynamic> wordData = word.toJson();
    _api.createWord(wordData);
  }
}