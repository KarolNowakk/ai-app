import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/screens/chat/chat_list.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/history/elements/history_drawer.dart';
import 'package:flutter/material.dart';
import 'chat_input.dart';
import 'package:provider/provider.dart';

class BasicConversationScreen extends StatefulWidget {
  static const String route = "basic_conversation";

  BasicConversationScreen({super.key});

  final List<Widget> messages = [];

  @override
  State<BasicConversationScreen> createState() => _BasicConversationScreenState();
}

class _BasicConversationScreenState extends State<BasicConversationScreen> {
  final FocusNode _chatFieldFocus = FocusNode();

  ConversationProvider? _tempConvProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tempConvProvider = context.read<ConversationProvider>();
  }

  @override
  void dispose() {
    _tempConvProvider?.reset();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      drawer: HistoryDrawer(
        parentId: context.read<ConversationProvider>().presetId
      ),
      actions: [
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
            ChatList(markdownMessage: true),
            ChatInput(),
          ],
        ),
      ),
    );
  }
}