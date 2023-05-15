class AIConversation {
  static const gpt3turbo = "gpt-3.5-turbo";
  static const gpt4 = "gpt-4";

  final String? title;
  final String? model;
  final int? completionChoices;
  final int? maxTokens;
  double? temperature;
  double? topP;
  List<Message>? messages;

  AIConversation({
    this.title,
    this.model,
    this.messages,
    this.temperature,
    this.topP,
    this.completionChoices,
    this.maxTokens
  });

  @override
  String toString() {
    return 'AIConversation '
      'model: $model'
      'messages: ${messages?.map((message) => message.toString()).join(', ')},'
      'temperature: $temperature,'
      'topP: $topP,'
      'completionChoices: $completionChoices,'
      'maxTokens: $maxTokens';
  }

  factory AIConversation.fromJson(Map<String, dynamic> json) {
    return AIConversation(
      title: json['title'],
      model: json['model'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['topP'] as num?)?.toDouble(),
      completionChoices: json['completionChoices'] as int?,
      maxTokens: json['maxTokens'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'model': model,
      'messages': messages?.map((item) => item.toJson()).toList(),
      'temperature': temperature,
      'topP': topP,
      'completionChoices': completionChoices,
      'maxTokens': maxTokens,
    };
  }
}

class Message {
  static const roleUser = "user";
  static const roleAssistant = "assistant";
  static const roleSystem = "system";

  String role;
  String content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'Message(role: $role, content: $content)';
  }
}