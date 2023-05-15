import 'dart:developer';

import 'package:app2/plugins/lang/application/current_ecercise_repo.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/playground/domain/ai_service.dart';
import 'package:app2/plugins/playground/domain/conversation.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';

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
  final AIServiceInterface _aiService = KiwiContainer().resolve<AIServiceInterface>();
  late ExerciseStructure _exerciseStructure;
  final CurrentExerciseRepoInterface _currentExeRepo = KiwiContainer().resolve<CurrentExerciseRepoInterface>();
  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();

  WordExercisesController() {
    _wordsRepo.getAllWords().then((value) {
      _srsAlg.setAll(value);
    });

    _currentExeRepo.getExerciseSettings().then((value) => {
      _exerciseStructure = value!
    });
  }

  void resetConversation() {
    _currentExeRepo.getExerciseSettings().then((value) => {
      _exerciseStructure = value!
    });
  }

  Future<SendMsgResult> requestExercises() async {
    Message msg = _exerciseStructure.conv.messages!.removeLast();

    _exerciseStructure.conv.messages!.forEach((element) {
      log(element.toString());
    });

    WordData? wordUsed;

    if (_exerciseStructure.useSRS) {
      final word = _srsAlg.getNextWord();
      if (word != null) {
        msg.content = '${msg.content}'
            'Please use the following word: ${word.word}';

        wordUsed = word;
      }
    }

    _exerciseStructure.conv.messages!.add(msg);
    Stream<String> result = _aiService.kindlyAskAI(_exerciseStructure.conv);

    return SendMsgResult(sentence: result, data: wordUsed);
  }

  Stream<String> sendAMessage(BuildContext context, String msg) {
    _exerciseStructure.conv.temperature = _exerciseStructure.tempForLater;

    Stream<String> stream = _aiService.kindlyAskAI(_exerciseStructure.conv);
    _listenToStream(stream);

    return stream;
  }

  void _listenToStream(Stream<String> stream) {
    String text = "";
    stream.listen((data) {
        text += data;
    }, onDone: () {
      addMessage(Message.roleAssistant, text);
    },onError: (error) {
      log('Error: $error');
    });
  }

  void addMessage(String role, String content) {
    _exerciseStructure.conv.messages!.add(Message(
        role: role,
        content: content
    ));
  }
}
