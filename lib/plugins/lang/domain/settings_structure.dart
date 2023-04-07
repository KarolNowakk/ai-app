const userRole = "user";
const systemRole = "system";
const assistantRole = "assistant";

class ExerciseStructure {
  String id;
  String text;
  bool useSRS;
  String title;
  List<Message> messages;

  ExerciseStructure({
    required this.id,
    required this.text,
    required this.useSRS,
    required this.title,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> messageJsonList = messages.map((message) => message.toJson()).toList();

    return {
      'id': id,
      'text': text,
      'useSRS': useSRS,
      'title': title,
      'messages': messageJsonList,
    };
  }

  static ExerciseStructure fromJson(Map<String, dynamic> json) {
    List<dynamic> messageListJson = json['messages'];

    List<Message> messageList = messageListJson.map((messageJson) => Message.fromJson(messageJson)).toList();

    return ExerciseStructure(
      id: json['id'],
      text: json['text'],
      useSRS: json['useSRS'],
      title: json['title'],
      messages: messageList,
    );
  }
}

class Message {
  String role;
  String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  // Creates a message object from a JSON representation
  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  // Returns a string representation of the message object
  @override
  String toString() {
    return '$role: $content';
  }
}