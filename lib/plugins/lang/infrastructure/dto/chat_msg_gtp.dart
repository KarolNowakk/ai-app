class ChatMsgGPT {
  String id;
  String object;
  int created;
  String model;
  List<ChatCompletionChoice> choices;
  ChatCompletionUsage usage;

  ChatMsgGPT(
      {required this.id,
        required this.object,
        required this.created,
        required this.model,
        required this.choices,
        required this.usage});

  factory ChatMsgGPT.fromJson(Map<String, dynamic> json) {
    return ChatMsgGPT(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices: (json['choices'] as List)
          .map((choiceJson) => ChatCompletionChoice.fromJson(choiceJson))
          .toList(),
      usage: ChatCompletionUsage.fromJson(json['usage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'choices': choices.map((choice) => choice.toJson()).toList(),
      'usage': usage.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class ChatCompletionChoice {
  ChatCompletionMessage message;
  String finishReason;
  int index;

  ChatCompletionChoice(
      {required this.message, required this.finishReason, required this.index});

  factory ChatCompletionChoice.fromJson(Map<String, dynamic> json) {
    return ChatCompletionChoice(
      message: ChatCompletionMessage.fromJson(json['message']),
      finishReason: json['finish_reason'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(),
      'finish_reason': finishReason,
      'index': index,
    };
  }
}

class ChatCompletionMessage {
  String role;
  String content;

  ChatCompletionMessage({required this.role, required this.content});

  factory ChatCompletionMessage.fromJson(Map<String, dynamic> json) {
    return ChatCompletionMessage(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class ChatCompletionUsage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  ChatCompletionUsage(
      {required this.promptTokens,
        required this.completionTokens,
        required this.totalTokens});

  factory ChatCompletionUsage.fromJson(Map<String, dynamic> json) {
    return ChatCompletionUsage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}
