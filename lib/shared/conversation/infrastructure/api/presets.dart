import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class PresetsApiClient {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();

  late final CollectionReference<Map<String, dynamic>> _coll;

  PresetsApiClient(String collectionName) {
    _coll = FirebaseFirestore.instance.collection(collectionName);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _coll
        .where('user_id', isEqualTo: _auth.getUser().id)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<void> create(Map<String, dynamic> data) async {
    data["user_id"] = _auth.getUser().id;
    await _coll.doc(data['id']).set(data);
  }

  Future<void> update(Map<String, dynamic> exerciseData) async {
    exerciseData["user_id"] = _auth.getUser().id;
    final docRef = _coll.doc(exerciseData['id']);
    await docRef.update(exerciseData);
  }

  Future<void> delete(String exerciseId) async {
    final docRef = _coll.doc(exerciseId);
    await docRef.delete();
  }
}
