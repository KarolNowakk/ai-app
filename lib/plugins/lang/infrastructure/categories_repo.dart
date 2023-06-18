import 'package:app2/plugins/lang/application/categories_repo.dart';
import 'package:app2/plugins/lang/domain/category.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class CategoriesRepo implements CategoriesRepoInterface{
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _coll = FirebaseFirestore.instance.collection('categories');

  Future<List<Map<String, dynamic>>> _fetchAll(String lang) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _coll
        .where('lang', isEqualTo: lang)
        .where('user_id', isEqualTo: _auth.getUser().id)
        .orderBy('last_used')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _fetchAllCreatedByUser(String lang) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _coll
        .where('lang', isEqualTo: lang)
        .where('user_id', isEqualTo: _auth.getUser().id)
        .where('is_user_created', isEqualTo: true)
        .orderBy('last_used')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data()..addAll({'id': doc.id}))
        .toList();
  }

  @override
  Future<List<Category>> getByLang(String lang) async {
    List<Map<String, dynamic>> rawList = await _fetchAll(lang);
    List<Category> list = rawList.map((cat) => Category.fromJson(cat)).toList();
    list = list.reversed.toList();

    return list;
  }

  @override
  Future<List<Category>> getOnlyUserCreated(String lang) async {
    List<Map<String, dynamic>> rawList = await _fetchAllCreatedByUser(lang);
    List<Category> list = rawList.map((cat) => Category.fromJson(cat)).toList();
    list = list.reversed.toList();

    return list;
  }

  @override
  Future<void> updateLastUsed(Category cat) async {
    _coll.doc(cat.id).update({
      "last_used": DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> createNewCategory(Category cat) async{
    Map<String, dynamic> data = cat.toJson();

    data["user_id"] = _auth.getUser().id;
    data['last_used'] = DateTime.now().toIso8601String();
    data.remove('id');

    await _coll.add(data)
        .then((value) => log("Data Written Successfully"))
        .catchError((error) => log("Failed to write data: $error"));
  }
}