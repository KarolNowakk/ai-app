import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/screens/auth/login.dart';
import 'package:app2/screens/auth/register.dart';
import 'package:app2/screens/auth/start.dart';
import 'package:app2/screens/config.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/plugins/playground/screens/main.dart';
import 'package:app2/plugins/words_lib/screens/words_list.dart';
import 'package:app2/screens/main.dart';
import 'package:app2/plugins/lang/screens/exercise/create.dart';
import 'package:app2/plugins/translate/screens/main_screen.dart';
import 'package:app2/plugins/words_lib/screens/lang_select.dart';
import 'package:app2/shared/conversation/screens/chat/main_chat.dart';
import 'package:app2/shared/conversation/screens/presets/create_preset.dart';
import 'package:app2/shared/conversation/screens/presets/select_screen.dart';
import 'package:flutter/material.dart';
import 'package:app2/plugins/lang/screens/chat/main_screen.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';

MaterialPageRoute route(settings) {
  WidgetBuilder? builder;

  switch (settings.name) {
    case BasicConversationScreen.route:
      builder = (BuildContext context) => BasicConversationScreen();
      break;
    case ExerciseHomeScreen.route:
      builder = (BuildContext context) => ExerciseHomeScreen();
      break;
    case '/exercise':
      builder = (BuildContext context) => ExercisesChatScreen();
      break;
    case '/exercise_selector':
      builder = (BuildContext context) => ExerciseSelectorScreen();
      break;
    case '/exercise_creator':
      final ExerciseStructure? value = settings.arguments as ExerciseStructure?;
      builder = (BuildContext context) => CreateExerciseScreen(exe: value);
      break;
    case '/config':
      builder = (BuildContext context) => BasicConfigScreen();
      break;
    case '/translator':
      builder = (BuildContext context) => TranslatorScreen();
      break;
    case LangSelectorScreen.route:
      builder = (BuildContext context) => LangSelectorScreen();
      break;
    case WordsListScreen.route:
      final String? value = settings.arguments as String?;
      builder = (BuildContext context) => WordsListScreen(lang: value ?? "");
      break;
    case PlaygroundScreen.route:
      final AIConversation? value = settings.arguments as AIConversation?;
      builder = (BuildContext context) => PlaygroundScreen(defaultConv: value);
      break;
    case StartScreen.route:
      builder = (BuildContext context) => StartScreen();
      break;
    case RegisterScreen.route:
      builder = (BuildContext context) => RegisterScreen();
      break;
    case LoginScreen.route:
      builder = (BuildContext context) => LoginScreen();
      break;
    case CreatePresetScreen.route:
      builder = (BuildContext context) => const CreatePresetScreen();
      break;
    case PresetsSelectorScreen.route:
      builder = (BuildContext context) => const PresetsSelectorScreen();
      break;
  }

  return MaterialPageRoute(builder: builder!);
}