import "dart:async";
import "dart:developer";
import "package:app2/plugins/lang/application/config.dart";
import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
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


    // log("------------------ ai_service -----------------");
    // conv.messages!.forEach((element) {
      log(conv.model!);
    //   log('TopP: ${conv.topP.toString()}');
    //   log('Temp: ${conv.temperature.toString()}');
    // });

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

  @override
  Future<String> kindlyAskAIForString(AIConversation conv) async {
    OpenAI.apiKey = _config.getEntry(openAIKey);

    OpenAIChatCompletionModel chatCompletion = await
    OpenAI.instance.chat.create(
      model: conv.model ?? AIConversation.gpt4,
      temperature: conv.temperature,
      topP: conv.topP,
      messages: mapMessageListToChatModelList(conv.messages!),
    );

    // log("------------------ ai_service -----------------");
    // conv.messages!.forEach((element) {
    log(conv.model!);
    //   log('TopP: ${conv.topP.toString()}');
    //   log('Temp: ${conv.temperature.toString()}');
    // });

    return chatCompletion.choices.first.message.content;
  }

  List<OpenAIChatCompletionChoiceMessageModel> mapMessageListToChatModelList(
      List<ChatCompletionMessage> messageList) {
    return messageList.map((message) {
      OpenAIChatMessageRole role = OpenAIChatMessageRole.user;

      switch (message.role) {
        case ChatCompletionMessage.roleSystem:
          role = OpenAIChatMessageRole.system;
          break;
        case ChatCompletionMessage.roleAssistant:
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
