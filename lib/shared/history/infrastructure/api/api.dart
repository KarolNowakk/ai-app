import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class ConvHistoryApiClient {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _exeCollection =
  FirebaseFirestore.instance.collection('history');

  Future<List<Map<String, dynamic>>> getAll(String parentId) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _exeCollection
        .where('user_id', isEqualTo: _auth.getUser().id)
        .where('parent_id', isEqualTo: parentId)
        .orderBy('created_at')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id} ))
        .toList();
  }

  Future<void> create(Map<String, dynamic> history) async {
    history["user_id"] = _auth.getUser().id;

    await _exeCollection.doc(history['id']).set(history);
  }

  Future<void> update(Map<String, dynamic> history) async {
    history["user_id"] = _auth.getUser().id;

    await _exeCollection.doc(history['id']).update(history);
  }

  Future<void> delete(String historyId) async {
    final docRef = _exeCollection.doc(historyId);
    await docRef.delete();
  }
}
