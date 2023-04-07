import 'package:app2/plugins/lang/domain/settings_structure.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class ExerciseSaverRepoInterface {
  void saveOrUpdateExercise(ExerciseStructure exercise);
}

class CreateExerciseScreen extends StatefulWidget {
  final ExerciseSaverRepoInterface _repo = KiwiContainer().resolve<ExerciseSaverRepoInterface>();

  void onSave(ExerciseStructure? data, String title, String promptText, bool useSRS) {
    ExerciseStructure dataToSave = ExerciseStructure(id: "", text: promptText, useSRS: useSRS, title: title, messages: []);
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
  bool _checkBoxValue = false;
  bool _initialAlreadyCalled = false;

  setInitialValues(ExerciseStructure data) {
    if (_initialAlreadyCalled) {
      return;
    }

    setState(() {
      _textField1Controller.text = data.title;
      _textField2Controller.text = data.text;
      _checkBoxValue = data.useSRS;
    });

    _initialAlreadyCalled = true;
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseStructure? data = ModalRoute.of(context)?.settings.arguments as ExerciseStructure?;
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
        body: Padding(
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
                'Prompt text (stuff that will be send to GPT):',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _textField2Controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start prompting...',
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
                      backgroundColor: mainColor, // Set the button's background color to blue
                    ),
                    onPressed: () {
                      widget.onSave(data,
                          _textField1Controller.text, _textField2Controller.text, _checkBoxValue);
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
    );
  }
}
