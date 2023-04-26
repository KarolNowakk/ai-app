import 'package:app2/elements/infinity_button.dart';
import 'package:app2/elements/text_field.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/elements/lang_dropdown.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class CreateWordRepoInterface {
  Future<void> addWordDataToList(WordData newData);
}

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

  @override
  void hideSaveWorldModal(BuildContext context) {
    if (_isModalVisible) {
      Navigator.pop(context);
      _isModalVisible = false;
    }
  }
}

class SaveWordModal extends StatelessWidget {
  final CreateWordRepoInterface _wordsRepo = KiwiContainer().resolve<CreateWordRepoInterface>();
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
    WordData data = createNewWordData(
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