import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/conversation/screens/chat/chat_messages.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
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
  final ScrollController _scrollController = ScrollController();

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

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      drawer: HistoryDrawer(
        parentId: context.read<PresetsProvider<PresetChat>>().currentItem!.id,
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                print("nic");
              });
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: _chatFieldFocus.unfocus,
                  child: Consumer<ConversationProvider>(
                    builder: (context, convProvider, _) {
                      final messages = convProvider.messages;
                      return ListView.builder(
                        cacheExtent: 100,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          try {
                            final currentPosition = _scrollController.position;
                            if (currentPosition.pixels == currentPosition.maxScrollExtent) {
                              _scrollToBottom();
                            }
                          } catch(e){}

                          if (message.role == ChatCompletionMessage.roleAssistant) {
                            return Message.aiMessage(content: message.content);
                          }
                          if (message.role == ChatCompletionMessage.roleUser) {
                            return Message.userMessage(content: message.content);
                          }

                          return const SizedBox.shrink();
                        },
                        controller: _scrollController,
                      );
                    },
                  )
                ),
              ),
            ),
            ChatInput(
              focus: _chatFieldFocus,
            ),
          ],
        ),
      ),
    );
  }
}
