import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/elements/lang_dropdown.dart';
import 'package:app2/shared/elements/screens/ai_conv.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExerciseCreatorScreen extends StatefulWidget {
  static const String route = "exercise_creator";

  const ExerciseCreatorScreen({super.key});

  @override
  State<ExerciseCreatorScreen> createState() => _ExerciseCreatorScreenState();
}

class _ExerciseCreatorScreenState extends State<ExerciseCreatorScreen> {
  ExerciseStructure? _exe;
  bool _useSRSValue = false;
  String _selectedLang = "german";
  int _numberOfWordsToUse = 1;
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _numberOfWordsToUseController = TextEditingController();

  PresetsProvider<ExerciseStructure>? _disposeTempProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposeTempProvider = context.read<PresetsProvider<ExerciseStructure>>();
  }

  @override
  void dispose() {
    _disposeTempProvider?.resetCurrent();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _exe = context.read<PresetsProvider<ExerciseStructure>>().currentItem();

    if (_exe != null) {
      _selectedLang = _exe!.lang;
      _useSRSValue = _exe!.useSRS;
      _numberOfWordsToUse = _exe!.numberOfWordsToUse;

      _numberOfWordsToUseController.text = '$_numberOfWordsToUse';
    }
  }

  void save(AIConversation conv) {
    _exe = context.read<PresetsProvider<ExerciseStructure>>().currentItem();

    ExerciseStructure newExe = ExerciseStructure(
        id: _exe?.id,
        title: conv.title,
        useSRS: _useSRSValue,
        lang: _selectedLang,
        numberOfWordsToUse: _numberOfWordsToUse,
        conv: conv,
    );

    context.read<PresetsProvider<ExerciseStructure>>().save(newExe);
  }

  void useSRS(bool value) {
    _useSRSValue = value;
  }

  void changeLang(String value) {
    _selectedLang = value;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAIConvCreateScreen(
      defaultConv: _exe != null ? _exe!.conv : null,
      action: save,
      additionalElements: [
        UseSRSCheckbox(
            changeValue: useSRS, checkBoxValue: _exe?.useSRS ?? false),
        LangDropdown(
          onChange: changeLang,
          selectedLang: _selectedLang,
        ),
        const SizedBox(height: 20),
        const Text(
          "Temperature used for next questions in exercise conversation:",
          style: TextStyle(
            color: DarkTheme.textColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Number of words to use:",
          style: TextStyle(
            color: DarkTheme.textColor,
          ),
        ),
        TextField(
          controller: _numberOfWordsToUseController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            _numberOfWordsToUse = int.parse(value);
          },
        ),

      ],
    );
  }
}

class UseSRSCheckbox extends StatefulWidget {
  bool checkBoxValue;
  final Function(bool value) changeValue;

  UseSRSCheckbox({super.key, required this.checkBoxValue, required this.changeValue});

  @override
  _UseSRSCheckboxState createState() => _UseSRSCheckboxState();
}

class _UseSRSCheckboxState extends State<UseSRSCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.checkBoxValue,
          onChanged: (value) {
            setState(() {
              widget.checkBoxValue = value!;
              widget.changeValue(value!);
            });
          },
        ),
        const Text(
          'Use SRS words.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
