import 'package:app2/plugins/lang/domain/category.dart';

abstract class CategoriesRepoInterface {
  Future<List<Category>> getByLang(String lang);
  Future<List<Category>> getOnlyUserCreated(String lang);
  Future<void> updateLastUsed(Category cat);
  Future<void> createNewCategory(Category cat);
}