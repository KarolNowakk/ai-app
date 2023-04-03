import 'package:app2/plugins/lang/application/word_structure.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:kiwi/kiwi.dart';
import 'settings_structure.dart';

abstract class ExercisesPromptSettingsInterface {
  Future<SettingsForPrompter> getSettingsPrompt();
}

abstract class WordsRepoPromptInterface {
  Future<List<WordData>> getAllWords();
}

abstract class SRSAlgInterface {
  WordData? getNextWord();
  void setAll(List<WordData> list);
}

class Prompter implements PrompterInterface{
  final ExercisesPromptSettingsInterface _promptRepo = KiwiContainer().resolve<ExercisesPromptSettingsInterface>();
  final WordsRepoPromptInterface _wordsRepo = KiwiContainer().resolve<WordsRepoPromptInterface>();
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();

  @override
  void init() async {
    _wordsRepo.getAllWords().then((value) {
      _srsAlg.setAll(value);
    });
  }

  @override
  Future<PrompterResult> getPrompt() async {
    final settings = await _promptRepo.getSettingsPrompt();
    String prompt = settings.prompt;

    WordData? wordUsed = null;

    if (settings.useSRS) {
      final word = _srsAlg.getNextWord();
      if (word != null) {
        prompt = '$prompt'
            'Please use the following word: ${word.word}';

        wordUsed = word;
      }
    }

    return PrompterResult(wordUsed, prompt);
  }
}