import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import "package:dart_openai/openai.dart";

abstract class AICommunicatorInterface {
  Stream<String> kindlyAskAI(String prompt);
  setMessageList(List<Message> msgList);
}