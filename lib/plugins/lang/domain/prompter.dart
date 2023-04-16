import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';

abstract class PrompterInterface {
  Future<PrompterResult> requestAnExercise();
  Future<List<Message>> getInitialMessages();
  void init();
}

class PrompterResult {
  final WordData? wordUsed;
  final String prompt;

  PrompterResult(this.wordUsed, this.prompt);
}
