import 'package:app2/plugins/lang/domain/settings_structure.dart';

abstract class AICommunicatorInterface {
  Future<String> kindlyAskAI(String prompt);
  setMessageList(List<Message> msgList);
}