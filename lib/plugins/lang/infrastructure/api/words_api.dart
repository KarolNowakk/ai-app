import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:kiwi/kiwi.dart';

class WordApiClient {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _wordsCollection =
      FirebaseFirestore.instance.collection('new_words');

  Future<List<Map<String, dynamic>>> getWordsForSRS(String lang, String cat) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _wordsCollection
        .where('lang', isEqualTo: lang)
        .where('user_id', isEqualTo: _auth.getUser().id)
        .where('next_review', isLessThan: DateTime.now().toIso8601String())
        .where('not_srs', isEqualTo: false)
        .where('categories', arrayContains: cat)
        .orderBy('next_review')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllWordsByLangAndCat(String lang, String cat) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _wordsCollection
        .where('lang', isEqualTo: lang)
        .where('user_id', isEqualTo: _auth.getUser().id)
        .where('not_srs', isEqualTo: false)
        .where('categories', arrayContains: cat)
        .orderBy('next_review')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getWordsByIds(List<String> ids) async {
    List<Map<String, dynamic>> result = [];

    for (var id in ids) {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _wordsCollection.doc(id).get();

      if (doc.exists) {
        result.add(doc.data()!..addAll({'id': doc.id}));
      }
    }

    return result;
  }

  Future<void> createWord(Map<String, dynamic> word) async {
    word["user_id"] = _auth.getUser().id;
    await _wordsCollection.add(word);
  }

  Future<void> updateWord(Map<String, dynamic> word) async {
    final String docId = word['id'];
    word["user_id"] = _auth.getUser().id;

    await _wordsCollection.doc(docId).update(word);
  }

  Future<void> deleteWord(String wordId) async {
    await _wordsCollection.doc(wordId).delete();
  }

  Future<void> updateCategories(Map<String, dynamic> data) async {
    _wordsCollection.doc(data['id']).update({
      "categories": data['categories'],
    });
  }
}
