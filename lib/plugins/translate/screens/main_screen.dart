import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart' as exe;
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:app2/plugins/translate/screens/chat_input.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Screen')),
      body: Center(
        child: ConfigurableTextField(
          controller: TextEditingController(),
          hintText: 'Testing Text Field...',
        ),
      ),
    );
  }
}


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
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final SaveWordModalInterface _saveWordModalController =
      KiwiContainer().resolve<SaveWordModalInterface>();
  final AICommunicatorInterface _ai =
      KiwiContainer().resolve<AICommunicatorInterface>();
  List<DropdownMenuItem<String>> listOfLanguages = [];
  String leftDropdown = "";
  String rightDropdown = "";

  List<Message> messages = [];
  final TextEditingController _chatTextController = TextEditingController();
  final TextEditingController _wordTextController = TextEditingController();
  final TextEditingController _contextTextController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    languages.forEach((e) {
      DropdownMenuItem<String> v =
          DropdownMenuItem<String>(value: e, child: Text(e));
      listOfLanguages.add(v);
    });

    leftDropdown = "English";
    rightDropdown = "Polish";
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
      messages.add(Message.text(text: msg, isUserMessage: isAIMessage));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  void addStreamMessage(
      BuildContext context, Stream<String> msg, bool isAIMessage) {
    setState(() {
      messages.add(Message.stream(textStream: msg, isUserMessage: isAIMessage));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
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
          const SizedBox(height: 15),
          Expanded(
            flex: 4,
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, top: 0, right: 15, bottom: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: leftDropdown,
                            isExpanded: true,
                            items: listOfLanguages,
                            onChanged: (value) {
                              setState(() {
                                leftDropdown = value ?? "Polish";
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: IconButton(
                            icon: const Icon(Icons.swap_horiz),
                            onPressed: () {
                              String temp = leftDropdown;
                              setState(() {
                                leftDropdown = rightDropdown;
                                rightDropdown = temp;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: rightDropdown,
                            isExpanded: true,
                            items: listOfLanguages,
                            onChanged: (value) {
                              setState(() {
                                rightDropdown = value ?? "Italian";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      child: ConfigurableTextField(
                        controller: _wordTextController,
                        hintText:
                        'Word or sentence that you want to translate...',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      child: ConfigurableTextField(
                        controller: _contextTextController,
                        hintText:
                        'Provide context for translation if you want...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          mainColor, // Set the button's background color to blue
                        ),
                        onPressed: () {
                          translate();
                        },
                        child: const Text(
                          'Translate',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              // color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return messages[index];
                      },
                      controller: scrollController,
                    ),
                  ),
                  ChatInput(
                    controller: _chatTextController,
                    sendAMessage: sendAMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class ConfigurableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  ConfigurableTextField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      style: TextStyle(fontSize: 18, color: Colors.black), // Add the text color here
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: accentColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
