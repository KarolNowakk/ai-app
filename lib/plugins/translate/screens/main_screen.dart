import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart' as exe;
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart' as save;
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/translate/screens/chat_input.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
// import 'package:app2/plugins/lang/screens/style/color.dart';

const List<String> languages = [
  "Polish",
  "English",
  "German",
  "Spanish",
  "Italian"
];

List<exe.Message> messagesForAI = [
  exe.Message(role: exe.systemRole, content: '''
  You are a professional translator of all languages. Follow those rules:
  1. If there are any bad words requested, just ignore them and explain meaning in the requested language without using bad words.
  2. If you are asked to translate only one word add example sentences and explain different contexts.  
'''),
];

class TranslatorScreen extends StatefulWidget {
  List<Message> messages = [];

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GlobalKey _translationInputKey = GlobalKey();
  bool showTranslationInput = true;

  final save.SaveWordModalInterface _saveWordModalController =
      KiwiContainer().resolve<save.SaveWordModalInterface>();
  final AICommunicatorInterface _ai =
      KiwiContainer().resolve<AICommunicatorInterface>();
  List<DropdownMenuItem<String>> listOfLanguages = [];
  String leftDropdown = "";
  String rightDropdown = "";
  double _msgPadding = 280;

  final TextEditingController _chatTextController = TextEditingController();
  final TextEditingController _wordTextController = TextEditingController();
  final TextEditingController _contextTextController = TextEditingController();
  final FocusNode _wordTextFocusNode = FocusNode();
  final FocusNode _contextTextFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    languages.forEach((e) {
      DropdownMenuItem<String> v =
          DropdownMenuItem<String>(value: e, child: Text(e));
      listOfLanguages.add(v);
    });

    leftDropdown = "German";
    rightDropdown = "Polish";
  }

  @override
  void dispose() {
    _wordTextFocusNode.dispose();
    _contextTextFocusNode.dispose();
    super.dispose();
  }

  void action() {
    bool isContextTextFocused =
        _contextTextFocusNode.hasFocus || _wordTextFocusNode.hasFocus;

    if (isContextTextFocused || _chatTextController.text == "") {
      translate();
      return;
    }

    sendAMessage(_chatTextController.text);
  }

  void translate() {
    String mes =
        "Translate this word or sentence '${_wordTextController.text}' from '$leftDropdown' to $rightDropdown.";

    if (_contextTextController.text != "") {
      mes += " Word was used in this context: ${_contextTextController.text}";
    }
    _ai.setMessageList(messagesForAI);
    Stream<String> data = _ai.kindlyAskAI(mes);
    addStreamMessage(context, data, true);
  }

  void sendAMessage(String msg) {
    addTextMessage(context, msg, false);
    Stream<String> result = _ai.kindlyAskAI(msg);
    addStreamMessage(context, result, true);
  }

  void addTextMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.text(text: msg, isAIMsg: isAIMessage, scrollToBottom: scrollToBottom));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  void addStreamMessage(
      BuildContext context, Stream<String> msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.stream(textStream: msg, isAIMsg: isAIMessage, scrollToBottom: scrollToBottom,));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  void _togglePadding() {
    setState(() {
      _msgPadding = _msgPadding == 280 ? 70.0 : 280.0;
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
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut);
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
            contextTextController: _contextTextController,
            wordTextFocusNode: _wordTextFocusNode,
            contextTextFocusNode: _contextTextFocusNode,
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
            children: [ChatInput(
              controller: _chatTextController,
              sendAMessage: action,
            ),]
          ),
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
  final TextEditingController contextTextController;
  final FocusNode wordTextFocusNode;
  final FocusNode contextTextFocusNode;
  final Function() paddingControl;

  TranslationInput({
    Key? key,
    required this.leftDropdown,
    required this.rightDropdown,
    required this.onLeftDropdownChange,
    required this.onRightDropdownChange,
    required this.listOfLanguages,
    required this.wordTextController,
    required this.contextTextController,
    required this.wordTextFocusNode,
    required this.contextTextFocusNode,
    required this.paddingControl,
  }) : super(key: key);

  @override
  _TranslationInputState createState() => _TranslationInputState();
}

class _TranslationInputState extends State<TranslationInput> {
  bool _isMinimized = false;
  double _inputHeight = 230.0;

  void _toggleMinimized() {
    setState(() {
      widget.paddingControl();
      _isMinimized = !_isMinimized;
      _inputHeight = _isMinimized ? 5.0 : 230.0;
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
                              widget.onLeftDropdownChange(value ?? "Italian");
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
                              widget.onRightDropdownChange(value ?? "Italian");
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
                        hintText:
                            'Word or sentence that you want to translate...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: ConfigurableTextField(
                        focusNode: widget.contextTextFocusNode,
                        controller: widget.contextTextController,
                        hintText:
                            'Provide context for translation if you want...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleMinimized,
              icon: Icon(
                _isMinimized
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
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
