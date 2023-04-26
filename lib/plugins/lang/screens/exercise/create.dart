import 'package:app2/elements/infinity_button.dart';
import 'package:app2/elements/text_field.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/elements/lang_dropdown.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class ExerciseSaverRepoInterface {
  void saveOrUpdateExercise(ExerciseStructure exercise);
}

class CreateExerciseScreen extends StatefulWidget {
  final ExerciseSaverRepoInterface _repo =
      KiwiContainer().resolve<ExerciseSaverRepoInterface>();

  void onSave(ExerciseStructure? data, String title, nextMsgText, systemMsg, lang,
      bool useSRS, List<Message> messages) {
    messages.insert(0, Message(role: systemRole, content: systemMsg));

    ExerciseStructure dataToSave = ExerciseStructure(
        id: "",
        text: nextMsgText,
        useSRS: useSRS,
        title: title,
        lang: lang,
        messages: messages,
    );

    if (data != null) {
      dataToSave.id = data.id;
    }

    return _repo.saveOrUpdateExercise(dataToSave);
  }

  @override
  _CreateExerciseScreenState createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final TextEditingController _textField1Controller = TextEditingController();
  final TextEditingController _textField2Controller = TextEditingController();
  final TextEditingController _systemMsgTextFieldController =
      TextEditingController();
  bool _checkBoxValue = false;
  bool _initialAlreadyCalled = false;
  String _selectedLang = "german";
  final List<CustomTextFieldRow> _textFields = [];

  @override
  void initState() {
    super.initState();
  }

  void changeLang(String value) {
    _selectedLang = value;
  }

  void _addTextField({String? initialText, String? initialDropdownValue}) {
    setState(() {
      int newIndex = _textFields.length + 1;
      _textFields.add(
        CustomTextFieldRow(
          index: newIndex,
          onTextChanged: (String text) {},
          onDropdownChanged: (String? newValue) {},
          initialText: initialText,
          initialDropdownValue: initialDropdownValue,
        ),
      );
    });
  }

  setInitialValues(ExerciseStructure data) {
    if (_initialAlreadyCalled) {
      return;
    }

    setState(() {
      _textField1Controller.text = data.title;
      _textField2Controller.text = data.text;
      _checkBoxValue = data.useSRS;
      _selectedLang = data.lang != "" ? data.lang : "german";

      data.messages.forEach((msg) {
        if (msg.role == systemRole) {
          _systemMsgTextFieldController.text = msg.content;
          return;
        }

        _addTextField(initialDropdownValue: msg.role, initialText: msg.content);
      });
    });

    _initialAlreadyCalled = true;
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseStructure? data =
        ModalRoute.of(context)?.settings.arguments as ExerciseStructure?;
    if (data != null) {
      setInitialValues(data);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Update or create new exercise.'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title of your exercise:',
                  style: TextStyle(
                    color: DarkTheme.textColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                DefaultTextWidget(
                    controller: _textField1Controller,
                    hint: 'Title of your wonderful exercise...',
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'System message:',
                  style: TextStyle(
                    color: DarkTheme.textColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                DefaultTextWidget(
                  controller: _systemMsgTextFieldController,
                  hint: 'System message...',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Continue exercise text:',
                  style: TextStyle(
                    color: DarkTheme.textColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                DefaultTextWidget(
                  controller: _textField2Controller,
                  hint: 'e.x. Now continue with next exercise.',
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: _textFields,
                ),
                InfinityButton(
                  onPressed: _addTextField,
                  text: 'Add message',
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: _checkBoxValue,
                      onChanged: (value) {
                        setState(() {
                          _checkBoxValue = value!;
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
                ),
                const SizedBox(height: 16.0),
                LangDropdown(
                  onChange: changeLang,
                  selectedLang: _selectedLang,
                ),
                const SizedBox(height: 16.0),
                InfinityButton(
                  text: 'Save',
                  onPressed: () {
                    List<Message> messages = [];

                    for (var textField in _textFields) {
                      textField.getData((text, dropdownValue) {
                        messages.add(
                            Message(role: dropdownValue, content: text));
                      });
                    }

                    widget.onSave(
                        data,
                        _textField1Controller.text,
                        _textField2Controller.text,
                        _systemMsgTextFieldController.text,
                        _selectedLang,
                        _checkBoxValue,
                        messages);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldRow extends StatefulWidget {
  final int index;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String?> onDropdownChanged;
  final String? initialText;
  final String? initialDropdownValue;
  late TextEditingController _textEditingController;
  late String _dropdownValue;
  late List<String> _dropdownItems;

  CustomTextFieldRow({
    Key? key,
    required this.index,
    required this.onTextChanged,
    required this.onDropdownChanged,
    this.initialText,
    this.initialDropdownValue,
  }) : super(key: key ?? GlobalKey<_CustomTextFieldRowState>());

  @override
  _CustomTextFieldRowState createState() => _CustomTextFieldRowState();

  void getData(void Function(String text, String dropdownValue) callback) {
    callback(_textEditingController.text, _dropdownValue);
  }
}

class _CustomTextFieldRowState extends State<CustomTextFieldRow> {
  @override
  void initState() {
    super.initState();
    widget._textEditingController =
        TextEditingController(text: widget.initialText);
    widget._dropdownItems = [userRole, assistantRole];
    widget._dropdownValue =
        widget.initialDropdownValue ?? widget._dropdownItems.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: widget._dropdownValue,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                widget._dropdownValue = newValue;
              });
              widget.onDropdownChanged(newValue);
            }
          },
          items: widget._dropdownItems.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
        SizedBox(height: 2),
        DefaultTextWidget(
            controller: widget._textEditingController,
            hint: "Message content...",
        )
      ],
    );
  }
}
