import 'package:app2/plugins/lang/application/word_structure.dart';
import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

abstract class RateWordModalInterface {
  void show(BuildContext context, WordData data);
}

class WordExercisesController {
  bool _wasPromptJustSend = false;
  WordData? _wordData = null;

  final PrompterInterface _prompter = KiwiContainer().resolve<PrompterInterface>();
  final AICommunicatorInterface _aiCommunicator = KiwiContainer().resolve<AICommunicatorInterface>();
  final RateWordModalInterface _wordModal = KiwiContainer().resolve<RateWordModalInterface>();

  Future<String> requestExercises() async{
    if (_wasPromptJustSend) {
      return "First answer recently requested prompt";
    }

    PrompterResult promptResult = await _prompter.getPrompt();

    String result = await _aiCommunicator.kindlyAskAI(promptResult.prompt);

    _wordData = promptResult.wordUsed;
    _wasPromptJustSend = true;

    return result;
  }

  Future<String> sendAMessage(BuildContext context, String msg) async {
    String result = await _aiCommunicator.kindlyAskAI(msg);

    WordData? data = _wordData;

    if (_wasPromptJustSend && data != null) {
        _wordModal.show(context, data);
    }

    _resetWordStuff();

    return result;
  }

  void _resetWordStuff() {
    _wordData = null;
    _wasPromptJustSend = false;
  }
}