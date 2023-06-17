import 'package:app2/plugins/translate/infrastrucutre/translate_conv.repo.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/elements/screens/ai_conv.dart';
import 'package:flutter/material.dart';

class CreateTranslateConvScreen extends StatefulWidget {
  static const String mini = "Mini Translator";
  static const String regular = "Regular Translator";
  static const String route = "translate_conv_creation";
  final String convKind;

  final Map<String, String> type = {
    mini: TranslateConvRepo.miniTranslatorConv,
    regular: TranslateConvRepo.translatorConv,
  };

  CreateTranslateConvScreen({super.key, required this.convKind});

  @override
  State<CreateTranslateConvScreen> createState() => _CreateTranslateConvScreenState();
}

class _CreateTranslateConvScreenState extends State<CreateTranslateConvScreen> {
  final TranslateConvRepo _repo = TranslateConvRepo();
  AIConversation? _preset;

  @override
  void initState() {
    super.initState();

    _repo.get(widget.type[widget.convKind]!).then((value) {
      setState(() {
        _preset = value;
      });
    });
  }

  void save(AIConversation conv) {
    _repo.save(widget.type[widget.convKind]!, conv);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AIConversation?>(
      future: _repo.get(widget.type[widget.convKind]!),
      builder: (BuildContext context, AsyncSnapshot<AIConversation?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();  // return a loading spinner or some other placeholder
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');  // handle the error appropriately
        } else {
          return DefaultAIConvCreateScreen(
            title: widget.convKind,
            defaultConv: snapshot.data,
            action: save,
          );
        }
      },
    );
  }}
