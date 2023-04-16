import 'package:app2/plugins/lang/screens/config.dart';
import 'package:app2/plugins/lang/screens/main.dart';
import 'package:app2/plugins/lang/screens/exercise/create.dart';
import 'package:app2/plugins/translate/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:app2/plugins/lang/screens/chat/main_screen.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (BuildContext context) => ExerciseHomeScreen(),
  '/exercise': (BuildContext context) => ExercisesChatScreen(),
  '/exercise_selector': (BuildContext context) => ExerciseSelectorScreen(),
  '/exercise_creator': (BuildContext context) => CreateExerciseScreen(),
  '/config': (BuildContext context) => BasicConfigScreen(),

  '/translator': (BuildContext context) => TranslatorScreen(),
};