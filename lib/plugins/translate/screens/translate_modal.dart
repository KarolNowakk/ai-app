import 'dart:developer';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:app2/plugins/translate/infrastrucutre/translate_conv.repo.dart';
import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class QuickTranslateModalController {
  void showQuickTranslateModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickTranslateModal(),
    );
  }
}

class QuickTranslateModal extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _msgTextController = TextEditingController();
  final AIServiceInterface _service = KiwiContainer().resolve<AIServiceInterface>();
  final TranslateConvRepo _convRepo = TranslateConvRepo();

  QuickTranslateModal({super.key});

  void _askForTranslation(BuildContext context) async {
    WordData? match = findMatch(context.read<ExerciseProvider>().currentWords(), _textController.text);
    if (match != null) {
      _msgTextController.text = match.description;
      return;
    }

    _msgTextController.text = "";
    ChatCompletionMessage msg = ChatCompletionMessage(
      role: ChatCompletionMessage.roleUser,
      content: _textController.text,
    );

    AIConversation conv = translateConv.copy();
    AIConversation? repoConv = await _convRepo.get(TranslateConvRepo.miniTranslatorConv);
    if (repoConv != null) {
      conv = repoConv;
    }

    conv.messages!.add(msg);

    Stream<String> stream = _service.kindlyAskAI(conv);
    _listenToStream(stream);
  }

  void _listenToStream(Stream<String> stream) {
    stream.listen((data) {
      _msgTextController.text += data;
    }, onError: (error) {
      log('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    var clipboardData = Clipboard.getData('text/plain').then((clipboardData) {
      if (clipboardData != null && clipboardData.text != "" && clipboardData.text != null) {
        _textController.text = clipboardData.text!;
        _askForTranslation(context);
      }
    });

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.all(16.0),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 550),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                hintText: 'Type new word...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: DarkTheme.backgroundDarker, // Change this to the desired color
                    width: 1.0, // Change this to the desired width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: DarkTheme.backgroundDarker, // Change this to the desired color
                    width: 2.0, // Change this to the desired width
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                // onChanged: widget._msgTextController,
                maxLines: null,
                controller: _msgTextController,
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
            InfinityButton(
                text: "Translate",
                onPressed: () {
                  _askForTranslation(context);
                }),
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

WordData? findMatch(List<WordData> list, String searchWord) {
  for (WordData item in list) {
    String lowerItemWord = item.word.toLowerCase();
    String lowerSearchWord = searchWord.toLowerCase();

    if (lowerItemWord.contains(lowerSearchWord)) {
      return item;
    }
  }

  return null;
}
