import "package:app2/plugins/lang/domain/AICommunicator.dart";
import "package:app2/plugins/lang/infrastructure/dto/text_completion.dart";
import "api/ai_request.dart";
import "dart:convert";

const String model = "text-davinci-003";
const double temperature = 0.5;
const double frequencyPenalty = 0.5;
const double presencePenalty = 0.5;
const double topP = 1.0;
const int maxTokens = 1024;

class AICommunicator implements AICommunicatorInterface{
  @override
  Future<String> kindlyAskAI(String prompt) async {
    Map<String, dynamic> requestData = {
      "model": model,
      "prompt": prompt,
      "temperature": temperature,
      "max_tokens": maxTokens,
      "top_p": topP,
      "frequency_penalty": frequencyPenalty,
      "presence_penalty": presencePenalty,
    };

    var jsonString = "";
    try {
      jsonString = await sendOpenAIRequest(requestData);
    } catch (error) {
      return error.toString();
    }

    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    TextCompletion textCompletion = TextCompletion.fromJson(jsonMap);

    return textCompletion.choices[0].text.trim();
  }
}
