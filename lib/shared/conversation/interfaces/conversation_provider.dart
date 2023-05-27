import 'dart:async';
import 'dart:developer';
import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/helpers/helpers.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';

class ConversationProvider with ChangeNotifier {
  final AIServiceInterface _aiService = KiwiContainer().resolve<AIServiceInterface>();
  final ConvHistoryRepoInterface _historyRepo = KiwiContainer().resolve<ConvHistoryRepoInterface>();

  String _historyId = "";
  String _presetId = "";
  bool _isCurrentlyStreaming = false;
  AIConversation? _conv;
  final List<ChatCompletionMessage> _messages = [];

  get messages => _messages;
  get presetId => _presetId;

  void setPresetId(String id) {
    _presetId = id;
  }

  void stopStream() {
    _isCurrentlyStreaming = false;
  }

  void reset() {
    stopStream();
    _conv = null;
    _messages.clear();
    _presetId = "";
    _historyId = "";
  }

  void setConversation(String presetId, AIConversation conversation) {
    _conv = conversation;
    _messages.clear();
    _messages.addAll(conversation.messages!);
    _presetId = presetId;
    notifyListeners();
  }

  void setMessagesFromHistory(ConvHistory history) {
    _messages.clear();
    _messages.addAll(history.msgs);
    _historyId = history.id;
    _presetId = history.parentId;
    notifyListeners();
  }

  void addMessage(String role, String content) {
    if (_isCurrentlyStreaming || content == "") return;

    _messages.add(ChatCompletionMessage(role: role, content: content));
    _askAI();

    saveConvToHistory();
    notifyListeners();
  }

  void _askAI() {
    _isCurrentlyStreaming = true;

    AIConversation convCopy = _conv!.copy();
    convCopy.messages!.clear();
    convCopy.messages!.addAll(_messages);

    Stream<String> stream = _aiService.kindlyAskAI(convCopy);

    String content = "";
    int counter = 0;

    StreamSubscription<String>? subscription;

    subscription = stream.listen((data) {
      if (_isCurrentlyStreaming == false) {
        subscription?.cancel();
      }

      content += data;
      counter++;

      if (counter % 3 == 0) {
        _addStreamMessage(content);
        notifyListeners();
      }
    }, onDone: () {
      _isCurrentlyStreaming = false;
      _addStreamMessage(content);

      saveConvToHistory();
    }, onError: (error) {
      _isCurrentlyStreaming = false;
      log('Error: $error');
    });
  }

  void _addStreamMessage(String content) {
    if (_messages.last.role == ChatCompletionMessage.roleAssistant) {
      _messages.removeLast();
    }

    _messages.add(ChatCompletionMessage(
      role: ChatCompletionMessage.roleAssistant,
      content: content,
    ));
  }

  void saveConvToHistory() {
    if (_presetId == "") return;

    if (_historyId == "") {
      _historyId = generateRandomString(19);

      ConvHistory convHistory = ConvHistory(
        id: _historyId,
        parentId: _presetId,
        msgs: _messages,
      );

      _historyRepo.create(convHistory);

      return;
    }

    ConvHistory convHistory = ConvHistory(
      id: _historyId,
      parentId: _presetId,
      msgs: _messages,
    );

    _historyRepo.update(convHistory);
  }
}
