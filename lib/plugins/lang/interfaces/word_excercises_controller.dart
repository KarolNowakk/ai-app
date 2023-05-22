import 'dart:developer';
import 'dart:math' as math;
import 'package:app2/plugins/lang/application/current_ecercise_repo.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/playground/domain/ai_service.dart';
import 'package:app2/plugins/playground/domain/conversation.dart';
import 'package:app2/shared/helpers/helpers.dart';
import 'package:app2/shared/helpers/list_of_context.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';

class SendMsgResult {
  Stream<String> sentence;
  List<WordData> data;
  String exeRequest;

  SendMsgResult({required this.sentence, required this.data, required this.exeRequest});

  @override
  String toString() {
    return 'sentence: $sentence'
        'wordData: ${data.toString()}';
  }
}

class WordExercisesController {
  final AIServiceInterface _aiService = KiwiContainer().resolve<AIServiceInterface>();
  final CurrentExerciseRepoInterface _currentExeRepo = KiwiContainer().resolve<CurrentExerciseRepoInterface>();
  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();
  final ConvHistoryRepoInterface _convRepo = KiwiContainer().resolve<ConvHistoryRepoInterface>();

  List<WordData> currentWords = [];

  WordExercisesController() {
    _currentExeRepo.getExerciseSettings().then((exe) {
      if (exe == null || !exe.useSRS) {
        return;
      }

      _wordsRepo.getAllWords().then((value) {
        _srsAlg.setAll(value);
      });
    });
  }

  Future<String> getId() async {
    ExerciseStructure? data = await _currentExeRepo.getExerciseSettings();

    return data != null || data!.id == null ? data!.id! : "issue_id";
  }

  int remainingWords() {
    return _srsAlg.remainingWords();
  }

  Future<SendMsgResult> requestExercises(List<ChatCompletionMessage> msgsFromConversation) async {
    ExerciseStructure? exerciseStructure = await _currentExeRepo.getExerciseSettings();
    if (exerciseStructure == null) {
      throw Exception("error getting exercise");
    }

    ChatCompletionMessage msg = exerciseStructure.conv.messages!.removeLast();

    msg.content = buildFirstMessageContent(msg.content,
      exerciseStructure.useSRS, exerciseStructure.numberOfWordsToUse);

    exerciseStructure.conv.messages!.add(msg);
    exerciseStructure.conv.messages!.addAll(msgsFromConversation);

    // exerciseStructure.conv.messages!.forEach((element) {
    //   log(element.toString());
    // });

    Stream<String> result = _aiService.kindlyAskAI(exerciseStructure.conv);

    return SendMsgResult(sentence: result, data: currentWords, exeRequest: msg.content);
  }

  String buildFirstMessageContent(String msg, bool useSRS, int numberOfWordsToUse) {
    msg = simpleStringReplace(msg);

    if (!useSRS) {
      return msg;
    }

    currentWords.clear();
    List<String> currentWordsAsStrings = [];

    for (int i = 0; i < numberOfWordsToUse; i++) {
      WordData? data = _srsAlg.getNextWord();

      if (data == null) {
        continue;
      }

      currentWords.add(data);
      currentWordsAsStrings.add(data.word);
    }

    msg = replaceWithAListOfStrings(msg, currentWordsAsStrings);

    return msg;
  }

  Future<Stream<String>> sendAMessage(List<ChatCompletionMessage> msgsFromConversation) async {
    ExerciseStructure? exerciseStructure = await _currentExeRepo.getExerciseSettings();
    if (exerciseStructure == null) {
      throw Exception("error getting exercise");
    }

    if (exerciseStructure.conv.messages!.length == 2) {
      exerciseStructure.conv.messages!.removeLast(); // it comes from outside, with used words, and context
    }

    exerciseStructure.conv.temperature = exerciseStructure.tempForLater;
    exerciseStructure.conv.messages!.addAll(msgsFromConversation);

    log("-----------TUTAJ-----------");
    exerciseStructure.conv.messages!.forEach((element) {
      log(element.toString());
    });

    Stream<String> stream = _aiService.kindlyAskAI(exerciseStructure.conv);

    return stream;
  }

  Future<List<WordData>> getUsedWords(List<String> ids) async{
    return await _wordsRepo.getByIds(ids);
  }

  void createConvHistory(String id, List<ChatCompletionMessage> msgsFromConversation) async {
    ConvHistory hist = await _buildConvHistory(id, msgsFromConversation);
    hist.additionalData = <String,dynamic> {
      ConvHistory.wordsListEntry:  currentWords.map((e) => e.id).toList()
    };

    _convRepo.createHistory(hist);
  }

  void updateConvHistory(String id, List<ChatCompletionMessage> msgsFromConversation) async {
    ConvHistory hist = await _buildConvHistory(id, msgsFromConversation);
    _convRepo.updateHistory(hist);
  }

  Future<ConvHistory> _buildConvHistory(String id, List<ChatCompletionMessage> msgsFromConversation) async {
    ExerciseStructure? exerciseStructure = await _currentExeRepo.getExerciseSettings();
    if (exerciseStructure == null) {
      throw Exception("error getting exercise");
    }

    exerciseStructure.conv.messages!.removeRange(1, exerciseStructure.conv.messages!.length);
    exerciseStructure.conv.messages!.addAll(msgsFromConversation);

    String parentId = await getId();
    return ConvHistory(
      id: id,
      parentId: parentId,
      conv: exerciseStructure.conv,
    );
  }
}

String simpleStringReplace(String input) {
  const String contextPattern = '###CONTEXT###';

  if (input.contains(contextPattern)) {
    return input.replaceAll(contextPattern, getRandomContext());
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