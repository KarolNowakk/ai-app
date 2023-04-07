import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';

class ExerciseHomeScreen extends StatefulWidget {
  ExerciseHomeScreen({Key? key}) : super(key: key);

  @override
  _ExerciseHomeScreenState createState() => _ExerciseHomeScreenState();
}

class _ExerciseHomeScreenState extends State<ExerciseHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Hello, how are you?"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
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
              margin: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/exercises');
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
    );
  }
}
