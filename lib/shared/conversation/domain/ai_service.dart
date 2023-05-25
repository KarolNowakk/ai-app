import 'package:app2/shared/conversation/domain/conversation.dart';

abstract class AIServiceInterface {
  Stream<String> kindlyAskAI(AIConversation conv);
}
