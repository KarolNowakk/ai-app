import 'package:app2/plugins/lang/application/exercise_repo.dart';
import 'package:app2/plugins/playground/domain/conversation.dart';
import 'package:app2/shared/elements/lang_dropdown.dart';
import 'package:app2/shared/elements/screens/ai_conv.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';

class CreateExerciseScreen extends StatefulWidget {
  final ExerciseStructure? exe;
  bool _useSRSValue = false;
  String _selectedLang = "german";
  double _temp = 0.1;
  int _numberOfWordsToUse = 1;

  CreateExerciseScreen({super.key, this.exe});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final ExerciseRepoInterface _repo =
      KiwiContainer().resolve<ExerciseRepoInterface>();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _numberOfWordsToUseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.exe != null) {
      widget._selectedLang = widget.exe!.lang;
      widget._temp = widget.exe!.tempForLater;
      widget._useSRSValue = widget.exe!.useSRS;
      widget._numberOfWordsToUse = widget.exe!.numberOfWordsToUse;

      _tempController.text = '${widget._temp}';
      _numberOfWordsToUseController.text = '${widget._numberOfWordsToUse}';
    }
  }

  void save(AIConversation conv) {
    ExerciseStructure newExe = ExerciseStructure(
        id: widget.exe?.id == "" || widget.exe?.id == null
            ? ""
            : widget.exe?.id,
        useSRS: widget._useSRSValue,
        lang: widget._selectedLang,
        tempForLater: widget._temp,
        numberOfWordsToUse: widget._numberOfWordsToUse,
        conv: conv);

    _repo.saveOrUpdateExercise(newExe);
  }

  void useSRS(bool value) {
    widget._useSRSValue = value;
  }

  void changeLang(String value) {
    widget._selectedLang = value;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAIConvCreateScreen(
      defaultConv: widget.exe != null ? widget.exe!.conv : null,
      action: save,
      additionalElements: [
        UseSRSCheckbox(
            changeValue: useSRS, checkBoxValue: widget.exe?.useSRS ?? false),
        LangDropdown(
          onChange: changeLang,
          selectedLang: widget._selectedLang,
        ),
        const SizedBox(height: 20),
        const Text(
          "Temperature used for next questions in exercise conversation:",
          style: TextStyle(
            color: DarkTheme.textColor,
          ),
        ),
        TextField(
          controller: _tempController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            double? number = double.tryParse(value);
            if (number != null) {
              if (number > 0.1 && number < 1) {
                widget._temp = number;
                return;
              }
              widget._temp = 0.1;
            }
          },
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
              widget._numberOfWordsToUse = int.parse(value);
            }),
      ],
    );
  }
}

class UseSRSCheckbox extends StatefulWidget {
  bool checkBoxValue;
  final Function(bool value) changeValue;

  UseSRSCheckbox(
      {super.key, required this.checkBoxValue, required this.changeValue});

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
