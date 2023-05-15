import "dart:async";
import "dart:developer";
import "package:app2/plugins/lang/application/config.dart";
import "package:app2/plugins/playground/domain/ai_service.dart";
import "package:app2/plugins/playground/domain/conversation.dart";
import "package:dart_openai/openai.dart";
import "package:kiwi/kiwi.dart";

class AIService implements AIServiceInterface{
  final Config _config = KiwiContainer().resolve<Config>();

  @override
  Stream<String> kindlyAskAI(AIConversation conv) {
    OpenAI.apiKey = _config.getEntry(openAIKey);

    Stream<OpenAIStreamChatCompletionModel> chatCompletion =
    OpenAI.instance.chat.createStream(
      model: conv.model ?? AIConversation.gpt4,
      temperature: conv.temperature,
      topP: conv.topP,
      messages: mapMessageListToChatModelList(conv.messages!),
    );


    log("------------------ ai_service -----------------");
    conv.messages!.forEach((element) {
      log(element.toString());
    });

    StreamController<String> listUpdateController = StreamController<String>.broadcast();

    chatCompletion.listen((chatStreamEvent) {
      String text = chatStreamEvent.choices.first.delta.content ?? "";

      listUpdateController.sink.add(text);
    },
      onDone: () {
        listUpdateController.close();
      },
      onError: (error) {
        print("Error occurred: $error");
      },
    );

    return listUpdateController.stream;
  }

  List<OpenAIChatCompletionChoiceMessageModel> mapMessageListToChatModelList(
      List<Message> messageList) {
    return messageList.map((message) {
      OpenAIChatMessageRole role = OpenAIChatMessageRole.user;

      switch (message.role) {
        case Message.roleSystem:
          role = OpenAIChatMessageRole.system;
          break;
        case Message.roleAssistant:
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
