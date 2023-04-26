import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:app2/plugins/words_lib/infrastructure/words_repo.dart';
import 'package:kiwi/kiwi.dart';

void setupWordsLib() {
  final container = KiwiContainer();

  container.registerSingleton<WordsRepoInterface>((c) => WordsRepo());
}