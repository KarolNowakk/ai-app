import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/shared/elements/lang_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class SaveWordModalController implements SaveWordModalInterface{
  bool _isModalVisible = false;

  @override
  void showSaveWordModal(BuildContext context, String text) {
    showDialog( context: context, builder: (context) => SaveWordModal(
        text: text,
      ),
    );

    _isModalVisible = true;
  }
}

class SaveWordModal extends StatelessWidget {
  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();
  final TextEditingController _textController;
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedLang = "german";

  SaveWordModal({
    Key? key,
    String? text,
  }) : _textController = TextEditingController(text: text),
        super(key: key);

  void selectLang(String value) {
    _selectedLang = value;
  }

  void save() {
    WordData data = WordData.createNewWordData(
        _textController.text,
      _descriptionController.text,
      _selectedLang,
    );

    _wordsRepo.addWordDataToList(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.all(16.0),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextWidget(
              controller: _textController,
              hint: 'Type new word...',
            ),
            const SizedBox(height: 10),
            DefaultTextWidget(
                controller: _descriptionController,
              hint: "Optional description...",
            ),
            const SizedBox(height: 10),
            LangDropdown(
              onChange: selectLang,
              selectedLang: _selectedLang,
            ),
            const SizedBox(height: 16.0),
            InfinityButton(
              text: "Save Word",
              onPressed: () {
                save();
                Navigator.pop(context);
              }
            ),
          ],
        ),
      ),
    );
  }
}