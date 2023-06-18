import 'package:app2/plugins/lang/application/categories_repo.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/category.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/shared/elements/lang_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class CreateCategoryModalController {
  @override
  void show(BuildContext context) {
    showDialog( context: context, builder: (context) => CreateCategoryModal());
  }
}

class CreateCategoryModal extends StatelessWidget {
  final CategoriesRepoInterface _catRepo = KiwiContainer().resolve<CategoriesRepoInterface>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedLang = "german";

  CreateCategoryModal({super.key});

  void selectLang(String value) {
    _selectedLang = value;
  }

  void save() {
    if (_textController.text == "") {
      return;
    }

    Category data = Category(
        name: _textController.text.trim(),
        lang: _selectedLang,
        id: "",
        isUserCreated: true,
    );

    _catRepo.createNewCategory(data);
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
              hint: 'Category...',
            ),
            const SizedBox(height: 10),
            LangDropdown(
              onChange: selectLang,
              selectedLang: _selectedLang,
            ),
            const SizedBox(height: 16.0),
            InfinityButton(
                text: "Save",
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