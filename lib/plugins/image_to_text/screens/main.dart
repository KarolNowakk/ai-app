import 'package:app2/plugins/image_to_text/screens/recognizer.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/screens/chat/chat_input.dart';
import 'package:app2/plugins/translate/screens/translate_modal.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class LiveTextTranslation extends StatefulWidget {
  static const String route = "live_text_translation";

  const LiveTextTranslation({super.key});

  @override
  State<LiveTextTranslation> createState() => _LiveTextTranslationState();
}

class _LiveTextTranslationState extends State<LiveTextTranslation> {
  final SaveWordModalInterface _saveWordModalController = KiwiContainer().resolve<SaveWordModalInterface>();
  final QuickTranslateModalController _translateModalController = QuickTranslateModalController();
  final TextEditingController _txtCtrl = TextEditingController();

  @override
  void initState() {
    _txtCtrl.text = "Nothing recognized yet...";
    super.initState();
  }

  void getText(String recognizedText) {
    setState(() {
      _txtCtrl.text = recognizedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      // drawer: HistoryDrawer(
      //     parentId: context.read<ConversationProvider>().presetId
      // ),
      actions: [
        TextRecognizerView(func: getText),
        Center(
          child: IconButtonInput(
            icon: const Icon(Icons.translate, color: DarkTheme.textColor),
            action: () {
              _translateModalController.showQuickTranslateModal(context);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _saveWordModalController.showSaveWordModal(context, ""),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: TextField(
              // onChanged: widget._msgTextController,
              maxLines: null,
              controller: _txtCtrl,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
        )      ),
    );
  }
}