import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:app2/plugins/words_lib/infrastructure/api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class WordsRepo {
  final WordLibApiClient _api = KiwiContainer().resolve<WordLibApiClient>();

  Future<List<WordData>> getAllWords(String lang, DocumentSnapshot? lastDocument) async {
    List<Map<String, dynamic>> rawList = await _api.getAllWords(lang, startAfter: lastDocument);
    List<WordData> wordsList = rawList.map((exercise) => WordData.fromJson(exercise)).toList();

    return wordsList;
  }

  Future<void> updateWord(WordData updatedWordData) async {
    Map<String, dynamic> wordData = updatedWordData.toJson();
    _api.updateWord(wordData);
  }

  Future<void> addOneDayToNextReview(String id, DateTime nextReview) async {
    String data = nextReview.toIso8601String();
    _api.updateSingleField(id, WordData.nextReviewJson, data);
  }

  Future<void> notSRS(String id, bool value) async {
    _api.updateSingleField(id, WordData.notSRSJson, value);
  }

  Future<void> updateDescription(String id, String desc) async {
    _api.updateSingleField(id, WordData.descriptionJson, desc);
  }

  Future<void> updateWordText(String id, String text) async {
    _api.updateSingleField(id, WordData.wordJson, text);
  }
}