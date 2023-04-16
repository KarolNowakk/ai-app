import "dart:async";

import "package:app2/plugins/lang/application/config.dart";
import "package:app2/plugins/lang/domain/AICommunicator.dart";
import "package:app2/plugins/lang/domain/exercise_structure.dart";
import "package:dart_openai/openai.dart";
import "package:kiwi/kiwi.dart";

const String gpt = "gpt-3.5-turbo";
const String davinci = "text-davinci-003";
const String nwmCzy = "gpt-4";

const double temperature = 0.9;
const double frequencyPenalty = 0.5;
const double presencePenalty = 0.5;
const double topP = 1.0;
const int maxTokens = 1024;

class AICommunicator implements AICommunicatorInterface {
  final Config _config = KiwiContainer().resolve<Config>();
  List<Message> messageHistory = [];

  void addMessage(String role, String content) {
    messageHistory.add(Message(role: role, content: content));
  }

  @override
  void setMessageList(List<Message> msgList) {
    print("msgList");
    print(msgList);

    messageHistory = msgList;
  }

  @override
  Stream<String> kindlyAskAI(String prompt) {
    OpenAI.apiKey = _config.getEntry(openAIKey);

    addMessage(userRole, prompt);

    Stream<OpenAIStreamChatCompletionModel> chatCompletion =
    OpenAI.instance.chat.createStream(
      model: gpt,
      temperature: temperature,
      messages: mapMessageListToChatModelList(messageHistory),
    );

    StreamController<String> listUpdateController = StreamController<String>();

    String wholeMessage = "";
    chatCompletion.listen(
          (chatStreamEvent) {
        String text = chatStreamEvent.choices.first.delta.content ?? "";
        wholeMessage += text;

        listUpdateController.sink.add(text);
      },
      onDone: () {
        addMessage(assistantRole, wholeMessage);
        listUpdateController.close();
      },
      onError: (error) {
        print("Error occurred: $error");
      },
    );

    print(mapMessageListToChatModelList(messageHistory));

    return listUpdateController.stream;
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
