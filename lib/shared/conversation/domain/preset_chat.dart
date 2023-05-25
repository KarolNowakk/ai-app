import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/domain/preset.dart';

class PresetChat extends Preset{
  AIConversation conv;

  PresetChat({
    id = "",
    title = "",
    required this.conv,
  }) : super(
    id: id,
    title: title,
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> asJson = conv.toJson();

    asJson[Preset.jsonId] = id;
    asJson[Preset.jsonTitle] = title;

    return asJson;
  }

  static PresetChat fromJson(Map<String, dynamic> json) {
    AIConversation conv = AIConversation.fromJson(json);

    return PresetChat(
      id: json[Preset.jsonId],
      title: json[Preset.jsonTitle],
      conv: conv,
    );
  }

  static String collectionName() => 'presets';
}