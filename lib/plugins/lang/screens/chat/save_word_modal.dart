import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class CreateWordRepoInterface {
  Future<void> addWordDataToList(WordData newData);
}

abstract class CreateInitialSRSWordDataInterface {
  WordData createNewWordData(String word);
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
  final CreateInitialSRSWordDataInterface _srsAlg = KiwiContainer().resolve<CreateInitialSRSWordDataInterface>();
  final TextEditingController _textController;

  SaveWordModal({
    Key? key,
    String? text,
  }) : _textController = TextEditingController(text: text),
        super(key: key);

  void save() {
    WordData data = _srsAlg.createNewWordData(_textController.text);
    _wordsRepo.addWordDataToList(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Type new word...',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: textColor, // Change this to the desired color
                  width: 1.0, // Change this to the desired width
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: accentColor, // Change this to the desired color
                  width: 2.0, // Change this to the desired width
                ),
              ),
            ),
          ),

          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor, // Set the button's background color to blue
                ),
                onPressed: () {
                  save();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add word to SRS Library',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
