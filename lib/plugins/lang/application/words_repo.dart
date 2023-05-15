import 'package:app2/plugins/lang/domain/word_structure.dart';

abstract class WordsRepoInterface {
  Future<List<WordData>> getAllWords();
  Future<void> addWordDataToList(WordData word);
  Future<void> updateWordDataInList(WordData updatedWordData);
}