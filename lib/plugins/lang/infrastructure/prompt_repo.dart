import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/application/settings_structure.dart';

class PromptSettingsRepo implements ExercisesPromptSettingsInterface{
  @override
  Future<SettingsForPrompter> getSettingsPrompt() async {
    return SettingsForPrompter(
      prompt: 'Please give me a sentence in german on level B2. I will then translate this to polish and you will propose a different  better translation and explain why.',
      useSRS: true,
    );
  }
}

