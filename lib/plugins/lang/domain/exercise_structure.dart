import 'dart:convert';
import 'dart:developer';

import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/helpers/list_of_context.dart';

class ExerciseStructure extends Preset{
  bool useSRS;
  String lang;
  AIConversation conv;
  int numberOfWordsToUse;

  ExerciseStructure({
    id,
    title,
    required this.useSRS,
    required this.lang,
    required this.conv,
    required this.numberOfWordsToUse,
  }) : super(
    id: id,
    title: title ?? "error",
  );

  static String collectionName() => 'exercises';

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> asJson = conv.toJson();

    asJson['id'] = id;
    asJson['title'] = title;
    asJson['use_srs'] = useSRS;
    asJson['lang'] = lang;
    asJson['number_of_words_to_use'] = numberOfWordsToUse;

    return asJson;
  }

  static ExerciseStructure fromJson(Map<String, dynamic> json) {
    AIConversation conv = AIConversation.fromJson(json);

    return ExerciseStructure(
      id: json['id'],
      title: json['title'],
      useSRS: json['use_srs'],
      lang: json['lang'],
      numberOfWordsToUse: json['number_of_words_to_use'] ?? 1,
      conv: conv,
    );
  }

  ExerciseStructure copy() {
    return ExerciseStructure.fromJson(toJson());
  }
}