import 'package:app2/plugins/lang/domain/settings_structure.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';

abstract class PrompterInterface {
  Future<PrompterResult> getPrompt();
  Future<List<Message>> getInitialMessages();
  void init();
}

class PrompterResult {
  final WordData? wordUsed;
  final String prompt;

  PrompterResult(this.wordUsed, this.prompt);
}
