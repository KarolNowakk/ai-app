import 'package:app2/plugins/lang/domain/category.dart';

abstract class CategoriesRepoInterface {
  Future<List<Category>> getByLang(String lang);
  Future<void> updateLastUsed(Category cat);
}