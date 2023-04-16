import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class ExerciseSaverRepoInterface {
  void saveOrUpdateExercise(ExerciseStructure exercise);
}

class CreateExerciseScreen extends StatefulWidget {
  final ExerciseSaverRepoInterface _repo =
      KiwiContainer().resolve<ExerciseSaverRepoInterface>();

  void onSave(ExerciseStructure? data, String title, nextMsgText, systemMsg,
      bool useSRS, List<Message> messages) {
    messages.insert(0, Message(role: systemRole, content: systemMsg));

    ExerciseStructure dataToSave = ExerciseStructure(
        id: 0,
        text: nextMsgText,
        useSRS: useSRS,
        title: title,
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

  final List<CustomTextFieldRow> _textFields = [];

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

    return Container(
      color: backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Update or create new exercise.'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title of your exercise:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _textField1Controller,
                  decoration: const InputDecoration(
                    hintText: 'Title of your wonderful exercise...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textColor, // Change this to the desired color
                        width: 1.0, // Change this to the desired width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: accentColor, // Change this to the desired color
                        width: 2.0, // Change this to the desired width
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'System message:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _systemMsgTextFieldController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'e.x. Now continue with next exercise.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textColor, // Change this to the desired color
                        width: 1.0, // Change this to the desired width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: accentColor, // Change this to the desired color
                        width: 2.0, // Change this to the desired width
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Continue exercise text:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _textField2Controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'e.x. Now continue with next exercise.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textColor, // Change this to the desired color
                        width: 1.0, // Change this to the desired width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: accentColor, // Change this to the desired color
                        width: 2.0, // Change this to the desired width
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: _textFields,
                ),
                ElevatedButton(
                  onPressed: _addTextField,
                  child: const Text('Add message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mainColor, // Set the button's background color to blue
                  ),
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            mainColor, // Set the button's background color to blue
                      ),
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
                            _checkBoxValue,
                            messages);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
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
        TextField(
          decoration: const InputDecoration(
            hintText: 'Title of your wonderful exercise...',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor, // Change this to the desired color
                width: 1.0, // Change this to the desired width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: accentColor, // Change this to the desired color
                width: 2.0, // Change this to the desired width
              ),
            ),
          ),
          controller: widget._textEditingController,
          onChanged: widget.onTextChanged,
        ),
      ],
    );
  }
}
