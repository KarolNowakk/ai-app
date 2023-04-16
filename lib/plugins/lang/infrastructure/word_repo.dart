import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/lang/screens/chat/rate_modal.dart';
import 'package:app2/plugins/lang/screens/chat/save_word_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordRepo implements WordsRepoPromptInterface, WordRepoUpdateInterface, CreateWordRepoInterface{
  final WordApiClient _api = KiwiContainer().resolve<WordApiClient>();

  @override
  Future<List<WordData>> getAllWords() async {
    List<Map<String, dynamic>> rawList = await _api.getAllWords();

    List<WordData> wordsList = rawList.map((exercise) => WordData.fromJson(exercise)).toList();

    return wordsList;
  }


  @override
  Future<void> addWordDataToList(WordData word) async {
    Map<String, dynamic> wordData = word.toJson();
    printWithLineNumber(wordData);
    _api.createWord(wordData);
  }

  @override
  Future<void> updateWordDataInList(WordData updatedWordData) async {
      print(updatedWordData.id);

      Map<String, dynamic> wordData = updatedWordData.toJson();
      _api.updateWord(wordData);
  }



// @override
  // Future<void> addWordDataToList(WordData wordData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';
  //
  //   print(wordDataListJson);
  //
  //   final wordDataList = List.from(jsonDecode(wordDataListJson));
  //   wordDataList.add(wordData.toJson());
  //   prefs.setString(_wordDataKey, jsonEncode(wordDataList));
  // }
  //
  // @override
  // Future<List<WordData>> getAllWords() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';
  //   final wordDataList = List.from(jsonDecode(wordDataListJson));
  //   return wordDataList.map((item) => WordData.fromJson(item)).toList();
  // }
  //
  // @override
  // Future<void> updateWordDataInList(WordData updatedWordData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final wordDataListJson = prefs.getString(_wordDataKey) ?? '[]';
  //   final wordDataList = List.from(jsonDecode(wordDataListJson));
  //
  //   final updatedList = wordDataList.map((wordData) {
  //     if (wordData['word'] == updatedWordData.word) {
  //       return updatedWordData.toJson();
  //     } else {
  //       return wordData;
  //     }
  //   }).toList();
  //
  //   prefs.setString(_wordDataKey, jsonEncode(updatedList));
  // }
}

void printWithLineNumber(Object? message) {
  final trace = StackTrace.current;
  final stackTraceLines = trace.toString().split('\n');
  final callerFrame = stackTraceLines[1]; // Get the second line in the stack trace, which represents the caller

  final lineDetails = RegExp(r'\(.*\)').stringMatch(callerFrame);
  print('[$lineDetails] $message');
}