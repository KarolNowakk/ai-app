import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/exercises/rate_modal.dart';
import 'package:app2/plugins/lang/screens/exercises/save_word_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordRepo implements WordsRepoPromptInterface, WordRepoUpdateInterface, CreateWordRepoInterface{
  static const String _wordDataKey = 'word_data_key';

  @override
  Future<void> addWordDataToList(WordData wordData) async {
    final prefs = await SharedPreferences.getInstance();
    final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';

    print(wordDataListJson);

    final wordDataList = List.from(jsonDecode(wordDataListJson));
    wordDataList.add(wordData.toJson());
    prefs.setString(_wordDataKey, jsonEncode(wordDataList));
  }

  @override
  Future<List<WordData>> getAllWords() async {
    final prefs = await SharedPreferences.getInstance();
    final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';
    final wordDataList = List.from(jsonDecode(wordDataListJson));
    return wordDataList.map((item) => WordData.fromJson(item)).toList();
  }

  @override
  Future<void> updateWordDataInList(WordData updatedWordData) async {
    final prefs = await SharedPreferences.getInstance();
    final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';
    final wordDataList = List.from(jsonDecode(wordDataListJson));

    final updatedList = wordDataList.map((wordData) {
      if (wordData['word'] == updatedWordData.word) {
        return updatedWordData.toJson();
      } else {
        return wordData;
      }
    }).toList();

    prefs.setString(_wordDataKey, jsonEncode(updatedList));
  }
}