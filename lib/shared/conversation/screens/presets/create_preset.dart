import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/elements/screens/ai_conv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePresetScreen extends StatefulWidget {
  static const String route = "preset_creation";

  const CreatePresetScreen({super.key});

  @override
  State<CreatePresetScreen> createState() => _CreatePresetScreenState();
}

class _CreatePresetScreenState extends State<CreatePresetScreen> {
  PresetChat? _preset;
  PresetsProvider<PresetChat>? _disposeTempProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposeTempProvider = context.read<PresetsProvider<PresetChat>>();
  }

  @override
  void dispose() {
    _disposeTempProvider?.resetCurrent();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _preset = context.read<PresetsProvider<PresetChat>>().currentItem();
  }

  void save(AIConversation conv) {
    _preset = context.read<PresetsProvider<PresetChat>>().currentItem();
    PresetChat preset = PresetChat(id: _preset?.id, conv: conv);

    context.read<PresetsProvider<PresetChat>>().save(preset);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAIConvCreateScreen(
      defaultConv: _preset != null ? _preset!.conv : null,
      action: save,
    );
  }
}
