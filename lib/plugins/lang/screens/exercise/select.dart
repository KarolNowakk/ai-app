import 'package:app2/plugins/lang/application/current_ecercise_repo.dart';
import 'package:app2/plugins/lang/application/exercise_repo.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseSelectorScreen extends StatefulWidget {
  final ExerciseRepoInterface _exeRepo =
      KiwiContainer().resolve<ExerciseRepoInterface>();
  final CurrentExerciseRepoInterface _currentExeRepo =
      KiwiContainer().resolve<CurrentExerciseRepoInterface>();

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Choose your exercise.'),
      ),
      body: _buildListTiles(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      ExerciseStructure item, int index, CurrentExerciseRepoInterface repo) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(-3, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  repo.saveExerciseSettings(_items[index]).then((value) {
                    Navigator.pushNamed(context, '/exercise');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    item.conv.title ?? "some err",
                    style: const TextStyle(
                        color: DarkTheme.textColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/exercise_creator', arguments: _items[index]);
              },
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget._exeRepo.deleteExercise(_items[index]);
                  _items.removeAt(index);
                });
              },
            ),
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.copy),
              onPressed: () {
                ExerciseStructure exToCopy = _items[index];
                exToCopy.id = "";
                Navigator.pushNamed(context, '/exercise_creator', arguments: exToCopy);
                },
            )
          ],
        ),
      ),
    );
  }
}
