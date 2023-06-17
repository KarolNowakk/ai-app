import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/lang_dropdown.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';

class ChangeSTTLanguageModalController{
  void showQuickTranslateModal(BuildContext context) {
    showDialog( context: context, builder: (context) => ChangeSTTLanguageModal(),
    );
  }
}

class ChangeSTTLanguageModal extends StatelessWidget {
  final Config _config = KiwiContainer().resolve<Config>();
  final TextEditingController _textController = TextEditingController();

  final TextEditingController _msgTextController = TextEditingController();
  ChangeSTTLanguageModal({super.key});

  String _selectedLang = "german";

  void selectLang(String value) {
    _selectedLang = value;
  }

  _save() {
    String lang = _selectedLang;

    if (_textController.text != "") {
      lang = _textController.text == "guess" ? "" : _textController.text;
    }

    _config.saveConfig(sttLanguageKey, lang);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.all(16.0),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextWidget(
              controller: _textController,
              hint: 'Type new word...',
            ),
            const SizedBox(height: 10),
            LangDropdown(
              onChange: selectLang,
              selectedLang: _selectedLang,
            ),
            const SizedBox(height: 10),
            InfinityButton(
                text: "Save STT Lang",
                onPressed: () {
                  _save();
                  Navigator.pop(context);
                }
            ),
          ],
        ),
      ),
    );
  }
}

AIConversation translateConv = AIConversation(
  temperature: 0.1,
  topP: 0.1,
  model: AIConversation.gpt3turbo,
  messages: [
    ChatCompletionMessage(
      role: ChatCompletionMessage.roleSystem,
      content: "You are a translator, when user send a word (it will be in german) or sentence you translate it to polish. You are very concise.",
    ),
  ],
);