import 'package:app2/plugins/playground/domain/conversation.dart';

abstract class ConvHistoryRepoInterface {
  Future<List<ConvHistory>> getAllForParent(String parentId);
  Future<void> updateHistory(ConvHistory history);
  Future<void> createHistory(ConvHistory history);
  Future<void> deleteHistory(ConvHistory history);
}

class ConvHistory {
  static const String idJson = 'id';
  static const String parentIdJson = 'parent_id';
  static const String titleJson = 'title';
  static const String additionalDataJson = 'additional_data';
  static const String convJson = 'conv';

  static const String wordsListEntry = "words_list";

  final String id;
  final String parentId;
  final String? title;
  Map<String, dynamic>? additionalData;
  final AIConversation conv;

  ConvHistory({
    required this.id,
    required this.parentId,
    this.additionalData,
    this.title,
    required this.conv,
  });

  Map<String, dynamic> toJson() => {
    idJson: id,
    parentIdJson: parentId,
    titleJson: title,
    additionalDataJson: additionalData,
    convJson: conv.toJson(),
  };

  factory ConvHistory.fromJson(Map<String, dynamic> json) {
    return ConvHistory(
      id: json[idJson],
      parentId: json[parentIdJson],
      title: json[titleJson],
      additionalData: json[additionalDataJson],
      conv: AIConversation.fromJson(json[convJson]),
    );
  }
}
