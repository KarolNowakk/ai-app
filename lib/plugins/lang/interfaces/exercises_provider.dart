import 'dart:io';
import 'package:app2/plugins/lang/application/categories_repo.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/category.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/helpers/list_of_context.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';

class ExerciseProvider with ChangeNotifier {
  late ConversationProvider _convProvider;
  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();
  final CategoriesRepoInterface _catRepo = KiwiContainer().resolve<CategoriesRepoInterface>();
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();
  final List<WordData> _wordList = [];
  final List<WordData> _wordListNotRemovable = []; // used to search for words in translations
  final List<WordData> _wordsToEvaluate = [];
  final List<Category> _catList = [];
  bool getAllWords = false;

  ExerciseStructure? _exe;

  ExerciseProvider(BuildContext context) {
    _convProvider = Provider.of<ConversationProvider>(context, listen: false);
  }

  int get wordsCount => _wordList.length;

  List<WordData> get wordsToEvaluate => _wordsToEvaluate;
  List<WordData> currentWords() => _wordListNotRemovable;

  List<String> get categoryList => _catList.map((category) => category.name).toList();

  List<Category> get userCreatedCategories =>
      _catList.where((category) => category.isUserCreated).toList();

  void reset() {
    _wordList.clear();
    _wordsToEvaluate.clear();
    _catList.clear();
    _exe = null;
    _convProvider.reset();
  }

  void deleteEvaluatedWord(int index) {
    _wordsToEvaluate.removeAt(index);
    notifyListeners();
  }

  void setExercise(ExerciseStructure exe) async {
    _exe = exe;

    if (exe.useSRS) {
      _catRepo.getByLang(exe.lang).then((value) {
        _catList.clear();
        _catList.addAll(value);
        notifyListeners();
      });
    }

    _wordsRepo.getByLangAndCategory(exe.lang, "My own", getAll: getAllWords).then((list) {
      _updateWordsList(list);
      _wordListNotRemovable.clear();
      _wordListNotRemovable.addAll(list);

      AIConversation convCopy = exe.conv.copy();
      convCopy.messages!.removeRange(1, convCopy.messages!.length);

      _convProvider.setConversation(exe.id, convCopy);
      notifyListeners();
    });
  }

  void loadNewWords(String category) {
    _wordsRepo.getByLangAndCategory(_exe!.lang, category, getAll: getAllWords).then((list) {
      _updateWordsList(list);
      _wordListNotRemovable.clear();
      _wordListNotRemovable.addAll(list);

      Category? foundCategory;

      for (Category cat in _catList) {
        if (cat.name == category) {
          foundCategory = cat;
          break;
        }
      }

      if (foundCategory != null) {
        _catRepo.updateLastUsed(foundCategory);
      }

      notifyListeners();
    });
  }

  void _updateWordsList(List<WordData> list) {
    _wordList.clear();
    _wordList.addAll(list);
  }

  void requestExercise() async {
    if (_exe == null) throw Exception("no exercise set");

    ExerciseStructure exeCopy = _exe!.copy();

    ChatCompletionMessage msg = exeCopy.conv.messages!.removeLast();
    String content = buildFirstMessageContent(msg.content, exeCopy.useSRS, exeCopy.numberOfWordsToUse);

    _convProvider.setConversation(exeCopy.id, exeCopy.conv);
    _convProvider.addMessage(ChatCompletionMessage.roleUser, content);

    notifyListeners();
  }

  String buildFirstMessageContent(String msg, bool useSRS, int numberOfWordsToUse) {
    msg = simpleStringReplace(msg);

    if (!_exe!.useSRS) {
      return msg;
    }

    _wordsToEvaluate.clear();
    List<String> currentWordsAsStrings = [];

    for (int i = 0; i < numberOfWordsToUse; i++) {
      NextWordResult result = _srsAlg.getNextWord(_wordList);
      _updateWordsList(result.list);

      if (result.word == null) continue;

      _wordsToEvaluate.add(result.word!);
      currentWordsAsStrings.add(result.word!.word);

      notifyListeners();
    }

    msg = replaceWithAListOfStrings(msg, currentWordsAsStrings);

    return msg;
  }
}

String simpleStringReplace(String input) {
  const String contextPattern = '###CONTEXT###';

  if (input.contains(contextPattern)) {
    return input.replaceAllMapped(contextPattern, (match) => getRandomContext());
  }

  return input;
}

String replaceWithAListOfStrings(String input, List<String> list) {
  const String contextPattern = '###WORDS###';

  if (input.contains(contextPattern)) {
    return input.replaceAll(contextPattern, list.join(", "));
  }

  return input;
}
