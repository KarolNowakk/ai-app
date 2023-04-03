import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/application/word_structure.dart';
import 'package:app2/plugins/lang/screens/rate_modal.dart';
import 'package:app2/plugins/lang/screens/save_word_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordRepo implements WordsRepoPromptInterface, WordRepoUpdateInterface, CreateWordRepoInterface{
  final String _key = "word_storage";

  @override
  Future<void> addWordDataToList(WordData newData) async {
    final prefs = await SharedPreferences.getInstance();
    final existingList = prefs.getStringList(_key);
    List<WordData> dataList = [];
    if (existingList != null) {
      try {
        dataList = existingList.map((e) => WordData.fromJson(jsonDecode(e))).toList();
      } catch(e) {
        print(e);
      }
    }

    dataList?.forEach((element) {
      print("-----------------");
      print(element);
    });


    final ddd = await prefs.getStringList(_key);

    ddd?.forEach((element) {
      print(element);
    });

    // Add the new data to the list
    dataList.add(newData);

    // Save the updated list back to storage as JSON
    final jsonList = dataList.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    print(jsonString);

    await prefs.setStringList(_key, [jsonString]);
  }

  @override
  Future<void> updateWordDataInList(WordData updatedWordData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wordDataJsonList = prefs.getStringList(_key) ?? [];

    int index = wordDataJsonList.indexWhere((element) => WordData.fromJson(jsonDecode(element)).word == updatedWordData.word);
    if (index != -1) {
      // WordData object with matching identifier found, update it
      wordDataJsonList[index] = jsonEncode(updatedWordData.toJson());
      await prefs.setStringList(_key, wordDataJsonList);
    }
  }

  @override
  Future<List<WordData>> getAllWords() async {
    final prefs = await SharedPreferences.getInstance();
    final listStr = prefs.getStringList(_key);
    if (listStr == null) {
      return []; // return empty list if no data found
    }
    try {
      final wordDataList =
      listStr.map((e) => WordData.fromJson(jsonDecode(e))).toList();
      print(wordDataList);
      return wordDataList;
    } catch (e) {
      return []; // return empty list on error
    }
  }
}