import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ExerciseHomeScreen extends StatefulWidget {
  final Config _configManager = KiwiContainer().resolve<Config>();

  ExerciseHomeScreen({Key? key}) : super(key: key);

  @override
  _ExerciseHomeScreenState createState() => _ExerciseHomeScreenState();
}

class _ExerciseHomeScreenState extends State<ExerciseHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadConfig() async {
    try {
      await widget._configManager.loadConfig();
    } on ConfigNotSetException catch (e) {
      print(e);
      Navigator.pushNamed(context, '/config');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadConfig();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white10,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 80,
                margin: const EdgeInsets.only(
                    left: 15, top: 10, right: 15, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercise_selector');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    textStyle: const TextStyle(fontSize: 32),
                  ),
                  child: const Text('Language Exercises'),
                ),
              ),
              // const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 80,
                margin: const EdgeInsets.only(
                    left: 15, top: 10, right: 15, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/translator');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    textStyle: const TextStyle(fontSize: 32),
                  ),
                  child: const Text('Translate'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
