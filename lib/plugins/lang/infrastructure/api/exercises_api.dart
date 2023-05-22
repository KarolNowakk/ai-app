import 'dart:developer';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseApiClient {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _exeCollection =
    FirebaseFirestore.instance.collection('exercises');

  Future<List<Map<String, dynamic>>> getAll() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _exeCollection
        .where('user_id', isEqualTo: _auth.getUser().id)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<void> create(Map<String, dynamic> exerciseData) async {
    exerciseData["user_id"] = _auth.getUser().id;

    await _exeCollection.add(exerciseData);
  }

  Future<void> update(Map<String, dynamic> exerciseData) async {
    exerciseData["user_id"] = _auth.getUser().id;
    final docRef = _exeCollection.doc(exerciseData['id']);
    await docRef.update(exerciseData);
  }

  Future<void> delete(String exerciseId) async {
    final docRef = _exeCollection.doc(exerciseId);
    await docRef.delete();
  }
}
