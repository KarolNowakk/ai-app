import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:flutter/material.dart';

abstract class SaveWordModalInterface {
  void showSaveWordModal(BuildContext context, String text);
}

abstract class WordsRepoInterface {
  Future<List<WordData>> getByLangAndCategory(String lang, String cat, {getAll = false});
  Future<void> addWordDataToList(WordData word);
  Future<void> updateWordDataInList(WordData updatedWordData);
  Future<List<WordData>> getByIds(List<String> listIds);
  Future<void> updateCategories(WordData data);
}