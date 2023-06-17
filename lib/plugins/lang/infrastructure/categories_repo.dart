import 'package:app2/plugins/lang/application/categories_repo.dart';
import 'package:app2/plugins/lang/domain/category.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CategoriesRepo implements CategoriesRepoInterface{
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();
  final CollectionReference<Map<String, dynamic>> _coll =
  FirebaseFirestore.instance.collection('categories');

  Future<List<Map<String, dynamic>>> _fetch(String lang) async {
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

  @override
  Future<List<Category>> getByLang(String lang) async {
    List<Map<String, dynamic>> rawList = await _fetch(lang);
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
}