import 'package:app2/shared/conversation/domain/conversation.dart';

abstract class ConvHistoryRepoInterface {
  Future<List<ConvHistory>> getAllForParent(String parentId);
  Future<void> update(ConvHistory history);
  Future<void> create(ConvHistory history);
  Future<void> delete(ConvHistory history);
}

class ConvHistory {
  static const String idJson = 'id';
  static const String parentIdJson = 'parent_id';
  static const String titleJson = 'title';
  static const String additionalDataJson = 'additional_data';
  static const String msgsJson = 'msgs';
  static const String wordsListEntry = "words_list";

  final String id;
  final String parentId;
  String? title;
  Map<String, dynamic>? additionalData;
  List<ChatCompletionMessage> msgs;

  ConvHistory({
    required this.id,
    required this.parentId,
    this.additionalData,
    this.title,
    required this.msgs,
  });

  Map<String, dynamic> toJson() => {
    idJson: id,
    parentIdJson: parentId,
    titleJson: title,
    additionalDataJson: additionalData,
    msgsJson: msgs.map((item) => item.toJson()).toList(),
  };

  factory ConvHistory.fromJson(Map<String, dynamic> json) {
    return ConvHistory(
      id: json[idJson],
      parentId: json[parentIdJson],
      title: json[titleJson],
      additionalData: json[additionalDataJson],
      msgs: (json[msgsJson] as List<dynamic>).map<ChatCompletionMessage>((item) =>
          ChatCompletionMessage.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}
