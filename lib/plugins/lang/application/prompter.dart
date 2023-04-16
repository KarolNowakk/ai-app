import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:kiwi/kiwi.dart';
import '../domain/exercise_structure.dart';

abstract class CurrentExerciseSettingsInterface {
  Future<ExerciseStructure?> getExerciseSettings();
}

abstract class WordsRepoPromptInterface {
  Future<List<WordData>> getAllWords();
}

abstract class SRSAlgInterface {
  WordData? getNextWord();
  void setAll(List<WordData> list);
}

class Prompter implements PrompterInterface{
  final CurrentExerciseSettingsInterface _currentExeRepo = KiwiContainer().resolve<CurrentExerciseSettingsInterface>();
  final WordsRepoPromptInterface _wordsRepo = KiwiContainer().resolve<WordsRepoPromptInterface>();
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();

  @override
  void init() async {
    _wordsRepo.getAllWords().then((value) {
      _srsAlg.setAll(value);
    });
  }

  @override
  Future<List<Message>> getInitialMessages() async {
    final settings = await _currentExeRepo.getExerciseSettings();
    if (settings == null) {
      throw Exception("exception getting initial messages");
    }

    return settings.messages;
  }

  @override
  Future<PrompterResult> requestAnExercise() async {
    final settings = await _currentExeRepo.getExerciseSettings();
    if (settings == null) {
      throw Exception("exception getting exercise settings");
    }

    String prompt = settings.text;

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