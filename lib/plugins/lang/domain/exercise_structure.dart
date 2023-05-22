import 'dart:convert';
import 'dart:developer';

import 'package:app2/plugins/playground/domain/conversation.dart';

class ExerciseStructure{
  String? id;
  bool useSRS;
  String lang;
  AIConversation conv;
  // regular temp is used for the first message, and later this temp is used
  // the idea is to avoid repeatable sentences that gpt is coming up with
  // but for explaining gpt should be more precise
  double tempForLater;
  int numberOfWordsToUse;

  ExerciseStructure({
    this.id,
    required this.tempForLater,
    required this.useSRS,
    required this.lang,
    required this.conv,
    required this.numberOfWordsToUse,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> asJson = conv.toJson();

    asJson['id'] = id;
    asJson['use_srs'] = useSRS;
    asJson['lang'] = lang;
    asJson['temp_for_later'] = tempForLater;
    asJson['number_of_words_to_use'] = numberOfWordsToUse;

    return asJson;
  }

  static ExerciseStructure fromJson(Map<String, dynamic> json) {
    AIConversation conv = AIConversation.fromJson(json);

    return ExerciseStructure(
      id: json['id'],
      useSRS: json['use_srs'],
      lang: json['lang'],
      tempForLater: json['temp_for_later'] ?? 0.1,
      numberOfWordsToUse: json['number_of_words_to_use'] ?? 1,
      conv: conv,
    );
  }
}