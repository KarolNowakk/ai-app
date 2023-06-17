import 'dart:developer';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/elements/record_button.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class ExerciseChatInput extends StatefulWidget {
  final RateWordModalInterface _rateWordModal = KiwiContainer().resolve<RateWordModalInterface>();

  ExerciseChatInput({super.key});

  @override
  State<ExerciseChatInput> createState() => _ExerciseChatInputState();
}

class _ExerciseChatInputState extends State<ExerciseChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  void getTranscription(String transcription) async {
    _controller.text += transcription;
    log("HERE: ${_controller.text}");
  }

  void send() {
    context.read<ConversationProvider>().addMessage(ChatCompletionMessage.roleUser, _controller.text);
    _controller.clear();
    _focus.unfocus();
  }

  void getNextExercise() async {
    ExerciseProvider exerciseProvider = context.read<ExerciseProvider>();
    await evaluateWords(exerciseProvider);
    exerciseProvider.requestExercise();
  }

  Future<void> evaluateWords(ExerciseProvider exerciseProvider) async {
    List<WordData> wordsCopy = List<WordData>.from(exerciseProvider.wordsToEvaluate);

    while(wordsCopy.isNotEmpty) {
      await widget._rateWordModal.show(context, wordsCopy[0]);
      exerciseProvider.deleteEvaluatedWord(0);
      wordsCopy.removeAt(0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        color: DarkTheme.primary,
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 5),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextField(
                  focusNode: _focus,
                  controller: _controller,
                  cursorColor: Colors.white,
                  // Set cursor color to white
                  style: const TextStyle(color: Colors.white),
                  // Set font color to white
                  decoration: const InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Type your message here...',
                    hintStyle: TextStyle(color: DarkTheme.textColor),
                    // Set hint text color to white
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => send,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
              ),
            ),
            IconButtonInput(
              action: send,
              icon: const Icon(
                Icons.send,
                color: DarkTheme.secondary,
                size: 30,
              ),
            ),
            _focus.hasFocus
                ? const SizedBox.shrink()
                : RecordButton(getTranscribedText: getTranscription),
            _focus.hasFocus
                ? const SizedBox.shrink()
                : GestureDetector(
                onLongPress: () => evaluateWords(context.read<ExerciseProvider>()),
                child: IconButtonInput(
                action: () => getNextExercise(),
                icon: const Icon(
                    Icons.replay,
                    color: DarkTheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonInput extends StatelessWidget {
  const IconButtonInput({
    super.key,
    required this.action,
    required this.icon,
  });

  final Function() action;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          color: DarkTheme.textColor,
        ),
      ),
      onPressed: action,
      child: icon,
    );
  }
}