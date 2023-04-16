import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';
import "package:dart_openai/openai.dart";

abstract class RateWordModalInterface {
  void show(BuildContext context, WordData data);
}

class SendMsgResult {
  Stream<String> sentence;
  WordData? data;

  SendMsgResult({required this.sentence, required this.data});

  @override
  String toString() {
    return 'sentence: $sentence'
        'wordData: ${data.toString()}';
  }
}

class WordExercisesController {
  final PrompterInterface _prompter = KiwiContainer().resolve<PrompterInterface>();
  final AICommunicatorInterface _aiCommunicator = KiwiContainer().resolve<AICommunicatorInterface>();

  WordExercisesController() {
    _prompter.init();
    _prompter.getInitialMessages().then((value) {
      _aiCommunicator.setMessageList(value);
    });
  }

  void resetConversation() {
    _prompter.getInitialMessages().then((value) {
      _aiCommunicator.setMessageList(value);
    });
  }

  Future<SendMsgResult> requestExercises() async {
    PrompterResult promptResult = await _prompter.requestAnExercise();
    Stream<String> result = _aiCommunicator.kindlyAskAI(promptResult.prompt);

    return SendMsgResult(sentence: result, data: promptResult.wordUsed);
  }

  Stream<String> sendAMessage(BuildContext context, String msg) {
    return _aiCommunicator.kindlyAskAI(msg);
  }
}
