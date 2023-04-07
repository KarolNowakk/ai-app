import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

abstract class RateWordModalInterface {
  void show(BuildContext context, WordData data);
}

class SendMsgResult {
  String sentence;
  WordData? data;

  SendMsgResult({required this.sentence, required this.data});

  @override
  String toString() {
    return 'sentence: $sentence'
        'wordData: ${data.toString()}';
  }
}

class WordExercisesController {
  WordData? _wordData = null;

  final PrompterInterface _prompter =
      KiwiContainer().resolve<PrompterInterface>();
  final AICommunicatorInterface _aiCommunicator =
      KiwiContainer().resolve<AICommunicatorInterface>();

  WordExercisesController() {
    _prompter.init();
    _prompter.getInitialMessages().then((value) {
      _aiCommunicator.setMessageList(value);
    });
  }

  void resetConversation() {
    _prompter.getInitialMessages().then((value) {
      _aiCommunicator.setMessageList(value);
    print("conversation kurwa zrresetowana do chuja pana");
    });
  }

  Future<String> requestExercises() async {
    PrompterResult promptResult = await _prompter.getPrompt();

    String result = await _aiCommunicator.kindlyAskAI(promptResult.prompt);

    _wordData = promptResult.wordUsed;

    return result;
  }

  Future<SendMsgResult> sendAMessage(BuildContext context, String msg) async {
    String result = await _aiCommunicator.kindlyAskAI(msg);

    WordData? data = _wordData;

    _resetWordStuff();

    return SendMsgResult(sentence: result, data: data);
  }

  void _resetWordStuff() {
    _wordData = null;
  }
}
