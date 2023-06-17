import 'dart:developer';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/translate/infrastrucutre/translate_conv.repo.dart';
import 'package:app2/plugins/translate/screens/create_translator_conv.dart';
import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/shared/conversation/domain/conversation.dart' as conv;
import 'package:app2/plugins/translate/screens/chat_input.dart';
import 'package:app2/shared/conversation/screens/presets/create_preset.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

conv.AIConversation translateConv = conv.AIConversation(
  model: conv.AIConversation.gpt4,
  temperature: 0.1,
  topP: 0.1,
  completionChoices: 1,
  messages: [],
);

List<conv.ChatCompletionMessage> defaultMessages = [
  conv.ChatCompletionMessage(
      role: conv.ChatCompletionMessage.roleSystem,
      content: 'Act as a very concise translator of all languages. If user asks for explaining, concisely explain.'),
  conv.ChatCompletionMessage(
    role: conv.ChatCompletionMessage.roleUser,
    content: '${TranslatorScreen.leftDropdownText} -> ${TranslatorScreen.rightDropdownText}, english: "${TranslatorScreen.wordText}"',
  )
];

class TranslatorScreen extends StatefulWidget {
  static const leftDropdownText = "###LEFT###";
  static const rightDropdownText = "###RIGHT###";
  static const wordText = "###WORD###";

  List<Message> messages = [];

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GlobalKey _translationInputKey = GlobalKey();
  bool showTranslationInput = true;

  final SaveWordModalInterface _saveWordModalController = KiwiContainer().resolve<SaveWordModalInterface>();
  final AIServiceInterface _ai = KiwiContainer().resolve<AIServiceInterface>();
  final TranslateConvRepo _convRepo = TranslateConvRepo();

  List<DropdownMenuItem<String>> listOfLanguages = [];
  String leftDropdown = "";
  String rightDropdown = "";
  double _msgPadding = 200;

  final TextEditingController _chatTextController = TextEditingController();
  final TextEditingController _wordTextController = TextEditingController();
  final FocusNode _wordTextFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    supportedLanguages.forEach((e) {
      DropdownMenuItem<String> v = DropdownMenuItem<String>(value: e, child: Text(e));
      listOfLanguages.add(v);
    });

    leftDropdown = "german";
    rightDropdown = "polish";
  }

  @override
  void dispose() {
    _wordTextFocusNode.dispose();
    translateConv.messages?.clear();
    super.dispose();
  }

  void action() {
    bool isContextTextFocused = _wordTextFocusNode.hasFocus;

    if (isContextTextFocused || _chatTextController.text == "") {
      translate();
      return;
    }

    sendAMessage(_chatTextController.text);
  }

  void translate() async {
    translateConv.messages!.clear();
    List<conv.ChatCompletionMessage> copiedList = defaultMessages.map((item) => item.copy()).toList();

    translateConv.messages!.addAll(List.from(copiedList));

    conv.AIConversation? repoConv = await _convRepo.get(TranslateConvRepo.translatorConv);
    if (repoConv != null) {
      translateConv = repoConv;
    }

    for (var i = 0; i < translateConv.messages!.length; i++) {
      String content = simpleStringReplace(translateConv.messages![i].content, TranslatorScreen.leftDropdownText, leftDropdown);
      content = simpleStringReplace(content, TranslatorScreen.rightDropdownText, rightDropdown);
      content = simpleStringReplace(content, TranslatorScreen.wordText, _wordTextController.text);

      translateConv.messages![i].content = content;
    }

    conv.AIConversation what = translateConv;
    List<conv.ChatCompletionMessage> defaultMessages1 = defaultMessages;


    askAI();
  }

  void sendAMessage(String msg) {
    addTextMessage(context, msg, false);

    translateConv.messages!.add(conv.ChatCompletionMessage(
      role: conv.ChatCompletionMessage.roleUser,
      content: msg,
    ));

    askAI();
  }

  void askAI() {
    Stream<String> result = _ai.kindlyAskAI(translateConv);
    addStreamMessage(context, result, true);
    _listenToStream(result);
  }

  void _listenToStream(Stream<String> stream) {
    String text = "";
    stream.listen((data) {
      setState(() {
        text += data;
      });
    }, onDone: () {
      translateConv.messages!.add(conv.ChatCompletionMessage(
        role: conv.ChatCompletionMessage.roleAssistant,
        content: text,
      ));
    }, onError: (error) {
      log('Error: $error');
    });
  }

  void addTextMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.text(text: msg, isAIMsg: isAIMessage, scrollToBottom: scrollToBottom));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  void addStreamMessage(BuildContext context, Stream<String> msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.stream(
        textStream: msg,
        isAIMsg: isAIMessage,
        scrollToBottom: scrollToBottom,
      ));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  void _togglePadding() {
    setState(() {
      _msgPadding = _msgPadding == 200 ? 70.0 : 200.0;
    });
  }

  void changeLeftDropDownSelection(String value) {
    setState(() {
      leftDropdown = value;
    });
  }

  void changeRightDropDownSelection(String value) {
    setState(() {
      rightDropdown = value;
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, CreateTranslateConvScreen.route, arguments: CreateTranslateConvScreen.mini);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, CreateTranslateConvScreen.route, arguments: CreateTranslateConvScreen.regular);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _saveWordModalController.showSaveWordModal(context, "");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TranslationInput(
            key: _translationInputKey,
            leftDropdown: leftDropdown,
            rightDropdown: rightDropdown,
            onLeftDropdownChange: changeLeftDropDownSelection,
            onRightDropdownChange: changeRightDropDownSelection,
            listOfLanguages: listOfLanguages,
            wordTextController: _wordTextController,
            wordTextFocusNode: _wordTextFocusNode,
            paddingControl: _togglePadding,
          ),
          Expanded(
            child: ListView.builder(
              cacheExtent: 100,
              itemCount: widget.messages.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                if (widget.messages.isNotEmpty) {
                  return widget.messages[index];
                }
              },
            ),
          ),
          Flex(
              direction: Axis.vertical,
              // height: 100,
              children: [
                ChatInput(
                  controller: _chatTextController,
                  sendAMessage: action,
                ),
              ]),
        ],
      ),
    );
  }
}

class TranslationInput extends StatefulWidget {
  String leftDropdown;
  String rightDropdown;
  Function(String) onLeftDropdownChange;
  Function(String) onRightDropdownChange;
  final List<DropdownMenuItem<String>> listOfLanguages;
  final TextEditingController wordTextController;
  final FocusNode wordTextFocusNode;
  final Function() paddingControl;

  TranslationInput({
    Key? key,
    required this.leftDropdown,
    required this.rightDropdown,
    required this.onLeftDropdownChange,
    required this.onRightDropdownChange,
    required this.listOfLanguages,
    required this.wordTextController,
    required this.wordTextFocusNode,
    required this.paddingControl,
  }) : super(key: key);

  @override
  _TranslationInputState createState() => _TranslationInputState();
}

class _TranslationInputState extends State<TranslationInput> {
  bool _isMinimized = false;
  double _inputHeight = 130.0;

  void _toggleMinimized() {
    setState(() {
      widget.paddingControl();
      _isMinimized = !_isMinimized;
      _inputHeight = _isMinimized ? 5.0 : 130.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _inputHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Theme.of(context).colorScheme.background,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            value: widget.leftDropdown,
                            isExpanded: true,
                            items: widget.listOfLanguages,
                            onChanged: (value) {
                              widget.onLeftDropdownChange(value ?? "italian");
                              // setState(() {
                              //   widget.leftDropdown = value ?? "Polish";
                              // });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: IconButton(
                            icon: const Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              String temp = widget.leftDropdown;
                              widget.onLeftDropdownChange(widget.rightDropdown);
                              widget.onRightDropdownChange(temp);
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Theme.of(context).colorScheme.background,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            value: widget.rightDropdown,
                            isExpanded: true,
                            items: widget.listOfLanguages,
                            onChanged: (value) {
                              widget.onRightDropdownChange(value ?? "italian");
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      child: ConfigurableTextField(
                        focusNode: widget.wordTextFocusNode,
                        controller: widget.wordTextController,
                        hintText: 'Word or sentence that you want to translate...',
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleMinimized,
              icon: Icon(
                _isMinimized ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigurableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;

  ConfigurableTextField({
    required this.controller,
    required this.hintText,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: null,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      // Add the text color here
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18, color: Color(0x80FFFFFF)),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.background,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

String simpleStringReplace(String input, String contextPattern, String replaceWith) {
  if (!input.contains(contextPattern)) {
    return input;
  }

  return input.replaceAll(contextPattern, replaceWith);
}
