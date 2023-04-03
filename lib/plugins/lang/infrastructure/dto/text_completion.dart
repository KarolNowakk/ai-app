class TextCompletion {
  String id;
  String object;
  int created;
  String model;
  List<TextCompletionChoice> choices;
  TextCompletionUsage usage;

  TextCompletion(
      {required this.id,
        required this.object,
        required this.created,
        required this.model,
        required this.choices,
        required this.usage});

  factory TextCompletion.fromJson(Map<String, dynamic> json) {
    return TextCompletion(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices: (json['choices'] as List)
          .map((choiceJson) => TextCompletionChoice.fromJson(choiceJson))
          .toList(),
      usage: TextCompletionUsage.fromJson(json['usage']),
    );
  }
}

class TextCompletionChoice {
  String text;
  int index;
  dynamic logprobs;
  String finishReason;

  TextCompletionChoice(
      {required this.text,
        required this.index,
        required this.logprobs,
        required this.finishReason});

  factory TextCompletionChoice.fromJson(Map<String, dynamic> json) {
    return TextCompletionChoice(
      text: json['text'],
      index: json['index'],
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }
}

class TextCompletionUsage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  TextCompletionUsage(
      {required this.promptTokens,
        required this.completionTokens,
        required this.totalTokens});

  factory TextCompletionUsage.fromJson(Map<String, dynamic> json) {
    return TextCompletionUsage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}