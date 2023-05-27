import 'package:app2/plugins/playground/infrastructure/ai_service.dart';
import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/shared/history/infrastructure/api/api.dart';
import 'package:kiwi/kiwi.dart';

class ConvHistoryRepo implements ConvHistoryRepoInterface {
  final ConvHistoryApiClient _api = KiwiContainer().resolve<ConvHistoryApiClient>();
  final AIServiceInterface _aiService = KiwiContainer().resolve<AIServiceInterface>();

  @override
  Future<List<ConvHistory>> getAllForParent(String parentId) async {
    List<Map<String, dynamic>> rawList = await _api.getAll(parentId);
    List<ConvHistory> historyList = rawList.map((exercise) => ConvHistory.fromJson(exercise)).toList();

    return historyList.reversed.toList();
  }

  @override
  Future<void> update(ConvHistory history) async {
    if (history.msgs.length == 3) {
      history.title = await getHistoryTitle(history);
      Map<String, dynamic> data = history.toJson();
      await _api.updateTitle(data);
    }

    Map<String, dynamic> data = history.toJson();
    _api.update(data);
  }

  @override
  Future<void> create(ConvHistory history) async {
    Map<String, dynamic> wordData = history.toJson();

    wordData["created_at"] = DateTime.now().toIso8601String();
    _api.create(wordData);
  }

  @override
  Future<void> delete(ConvHistory history) async {
    _api.delete(history.id);
  }

  Future<String> getHistoryTitle(ConvHistory history) async {
    String conv = "";

    history.msgs.forEach((msg) {
      if (msg.role == ChatCompletionMessage.roleSystem) return;

      conv += '\n role: ${msg.role} content: ${msg.content}';
    });

    AIConversation titleConvCopy = titleConv.copy();

    titleConvCopy.messages![1].content += conv;

    return _aiService.kindlyAskAIForString(titleConvCopy);
  }
}

AIConversation titleConv = AIConversation(
  temperature: 0.1,
  topP: 0.1,
  model: AIConversation.gpt3turbo,
  messages: [
    ChatCompletionMessage(
        role: ChatCompletionMessage.roleSystem,
        content: "Act as an AI that is coming up with very short titles of conversations provided.",
    ),
    ChatCompletionMessage(
      role: ChatCompletionMessage.roleUser,
      content: "Provide a title, not longer then 4 words for this conversation: ",
    ),
  ],
);