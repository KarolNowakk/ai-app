import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:app2/plugins/lang/screens/chat/category_selector.dart';
import 'package:app2/plugins/translate/screens/translate_modal.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/screens/chat/chat_list.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/history/elements/history_drawer.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'chat_input.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  static const String route = "exercise_conversation";

  ExerciseScreen({super.key});

  final List<Widget> messages = [];

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final SaveWordModalInterface _saveWordModalController = KiwiContainer().resolve<SaveWordModalInterface>();
  final QuickTranslateModalController _translateModalController = QuickTranslateModalController();
  final FocusNode _chatFieldFocus = FocusNode();

  ExerciseProvider? _tempExeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tempExeProvider = context.read<ExerciseProvider>();
  }

  @override
  void dispose() {
    _tempExeProvider?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      drawer: HistoryDrawer(
          parentId: context.read<ConversationProvider>().presetId
      ),
      actions: [
        CategorySelector(),
        Center(
          child: IconButtonInput(
            icon: const Icon(Icons.translate, color: DarkTheme.textColor),
            action: () {
              _translateModalController.showQuickTranslateModal(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '${context.watch<ExerciseProvider>().wordsCount}',
            style: const TextStyle(color: DarkTheme.textColor, fontSize: 22, fontWeight: FontWeight.bold),
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
        child: Column(
          children: [
            ChatList(markdownMessage: false), //TODO: make it configurable from a settings level
            ExerciseChatInput(),
          ],
        ),
      ),
    );
  }
}