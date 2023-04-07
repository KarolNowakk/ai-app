import "package:app2/plugins/lang/domain/AICommunicator.dart";
import "package:app2/plugins/lang/domain/settings_structure.dart";
import "package:app2/plugins/lang/infrastructure/dto/chat_msg_gtp.dart";
import "package:app2/plugins/lang/infrastructure/dto/chat_msg_text_davinci.dart";
import "package:dart_openai/openai.dart";
import "api/ai_request.dart";
import "dart:convert";

// const String model = "text-davinci-003";
const String gpt = "gpt-3.5-turbo";
const String davinci = "text-davinci-003";
const double temperature = 0.3;
const double frequencyPenalty = 0.5;
const double presencePenalty = 0.5;
const double topP = 1.0;
const int maxTokens = 1024;

class AICommunicator implements AICommunicatorInterface {
  List<Message> messageHistory = [];

  // bool _isFirstMessage = true;

  void addMessage(String role, String content) {
    messageHistory.add(Message(role: role, content: content));
  }

  @override
  void setMessageList(List<Message> msgList) {
    messageHistory = msgList;
  }

  @override
  Future<String> kindlyAskAI(String prompt) async {
    addMessage(userRole, prompt);

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: gpt,
      messages: mapMessageListToChatModelList(messageHistory),
    );

    String text = chatCompletion.choices.first.message.content;
    addMessage(assistantRole, text);

    return text;
  }

  List<OpenAIChatCompletionChoiceMessageModel> mapMessageListToChatModelList(
      List<Message> messageList) {
    return messageList.map((message) {
      OpenAIChatMessageRole role = OpenAIChatMessageRole.user;

      switch (message.role) {
        case systemRole:
          role = OpenAIChatMessageRole.system;
          break;
        case assistantRole:
          role = OpenAIChatMessageRole.assistant;
          break;
      }

      return OpenAIChatCompletionChoiceMessageModel(
        role: role,
        content: message.content,
      );
    }).toList();
  }
}
