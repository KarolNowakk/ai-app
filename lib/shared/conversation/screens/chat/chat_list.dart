import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/screens/chat/markdown_message.dart';
import 'package:app2/shared/conversation/screens/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';


class ChatList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final bool markdownMessage;

  ChatList({super.key, required this.markdownMessage});

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Consumer<ConversationProvider>(
              builder: (context, convProvider, _) {
                final messages = convProvider.messages;
                return ListView.builder(
                  cacheExtent: 100,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                  controller: _scrollController,
                );
              },
            )
        ),
      ),
    );
  }


  Widget _buildMessage(ChatCompletionMessage message) {
    try {
      final currentPosition = _scrollController.position;
      if (currentPosition.pixels == currentPosition.maxScrollExtent) {
        _scrollToBottom();
      }
    } catch(e){}

    if (message.role == ChatCompletionMessage.roleAssistant) {
      if (markdownMessage) return MarkdownMessage.aiMessage(content: message.content);
      return ChatMessage.aiMessage(content: message.content);
    }
    if (message.role == ChatCompletionMessage.roleUser) {
      if (markdownMessage) return MarkdownMessage.userMessage(content: message.content);
      return ChatMessage.userMessage(content: message.content);
    }

    return const SizedBox.shrink();
  }
}
