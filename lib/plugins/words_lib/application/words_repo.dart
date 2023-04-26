import 'package:app2/plugins/lang/domain/word_structure.dart';

abstract class WordsRepoInterface {
  Future<List<WordData>> getAllWords(String lang);
  Future<void> updateWord(WordData data);
}