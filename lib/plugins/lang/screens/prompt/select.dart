import 'package:app2/plugins/lang/domain/settings_structure.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class ExercisesRepoInterface {
  Future<List<ExerciseStructure>> getAllExercises();
  void deleteExercise(ExerciseStructure exercise);
}

abstract class CurrentExerciseSaverInterface {
  Future<void> saveExerciseSettings(ExerciseStructure exercise);
}

class ExerciseSelectorScreen extends StatefulWidget {
  final ExercisesRepoInterface _exeRepo =
      KiwiContainer().resolve<ExercisesRepoInterface>();
  final CurrentExerciseSaverInterface _currentExeRepo =
      KiwiContainer().resolve<CurrentExerciseSaverInterface>();

  @override
  _ExerciseSelectorScreenState createState() => _ExerciseSelectorScreenState();
}

class _ExerciseSelectorScreenState extends State<ExerciseSelectorScreen> {
  List<ExerciseStructure> _items = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await widget._exeRepo.getAllExercises();
    setState(() {
      _items = exercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Choose your exercise.'),
      ),
      body: _buildListTiles(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () {
          Navigator.pushNamed(context, '/exercise_creator');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTiles() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildListItem(item, index, widget._currentExeRepo);
      },
    );
  }

  Widget _buildListItem(
      ExerciseStructure item, int index, CurrentExerciseSaverInterface repo) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Set the radius to 8.0 pixels
        ),
        tileColor: mainColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        title: Text(
          item.title,
          style: const TextStyle(color: textColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: textColor,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/exercise_creator', arguments: _items[index]);
              },
            ),
            IconButton(
              color: textColor,
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget._exeRepo.deleteExercise(_items[index]);
                  _items.removeAt(index);
                });
              },
            ),
            IconButton(
              color: textColor,
              icon: const Icon(Icons.copy),
              onPressed: () {
                ExerciseStructure exToCopy = _items[index];
                exToCopy.id = "";
                Navigator.pushNamed(context, '/exercise_creator', arguments: exToCopy);
              },
            ),
          ],
        ),
        onTap: () {
          repo.saveExerciseSettings(_items[index]).then((value) {
            Navigator.pushNamed(context, '/exercise');
          });
        },
      ),
    );
  }
}
