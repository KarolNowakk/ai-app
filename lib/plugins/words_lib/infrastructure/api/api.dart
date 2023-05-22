import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class WordLibApiClient {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _wordsCollection =
  FirebaseFirestore.instance.collection('words');

  Future<List<Map<String, dynamic>>> getAllWords(String lang, {DocumentSnapshot? startAfter}) async {
    Query<Map<String, dynamic>> query = _wordsCollection
        .where('lang', isEqualTo: lang)
        .where('user_id', isEqualTo: _auth.getUser().id)
        .where('not_srs', isEqualTo: false)
        .orderBy('next_review')
        .limit(100);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<void> updateWord(Map<String, dynamic> word) async {
    final String docId = word['id'];
    word["user_id"] = _auth.getUser().id;

    await _wordsCollection.doc(docId).update(word);
  }

  Future<void> deleteWord(String wordId) async {
    await _wordsCollection.doc(wordId).delete();
  }

  Future<void> updateSingleField(String id, String fieldName, dynamic value) async{
    await _wordsCollection.doc(id).update({fieldName: value});
  }
}
