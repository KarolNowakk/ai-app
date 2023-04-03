import 'package:app2/plugins/lang/application/word_structure.dart';

abstract class PrompterInterface {
  Future<PrompterResult> getPrompt();
  void init();
}

class PrompterResult {
  final WordData? wordUsed;
  final String prompt;

  PrompterResult(this.wordUsed, this.prompt);
}
