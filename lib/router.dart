import 'package:app2/plugins/lang/screens/main.dart';
import 'package:app2/plugins/lang/screens/prompt/create.dart';
import 'package:flutter/material.dart';
import 'package:app2/plugins/lang/screens/exercises/main_screen.dart';
import 'package:app2/plugins/lang/screens/prompt/select.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (BuildContext context) => ExerciseHomeScreen(),
  '/exercise': (BuildContext context) => ExercisesChatScreen(),
  '/exercise_selector': (BuildContext context) => ExerciseSelectorScreen(),
  '/exercise_creator': (BuildContext context) => CreateExerciseScreen(),
};