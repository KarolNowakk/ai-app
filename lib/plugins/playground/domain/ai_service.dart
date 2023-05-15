import 'package:app2/plugins/playground/domain/conversation.dart';

abstract class AIServiceInterface {
  Stream<String> kindlyAskAI(AIConversation conv);
}
