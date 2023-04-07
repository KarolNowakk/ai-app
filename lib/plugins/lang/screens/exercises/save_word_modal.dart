import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/exercises/chat_messages.dart';
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
  final String text;

  SaveWordModal({
    Key? key,
    required this.text,
  }) : super(key: key);

  void save() {
    WordData data = _srsAlg.createNewWordData(text);
    _wordsRepo.addWordDataToList(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selected text: $text'),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  save();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
