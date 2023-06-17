import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/plugins/lang/injection_container.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:app2/plugins/playground/injection_container.dart';
import 'package:app2/plugins/words_lib/injection_container.dart';
import 'package:app2/screens/auth/splash.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/conversation/interfaces/presets_provider.dart';
import 'package:app2/shared/history/interfaces/history_provider.dart';
import 'package:app2/shared/injection_container.dart';
import 'package:app2/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  setupPlayground();
  setupLingApp();
  setupSharedStuff();
  setupWordsLib();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ChangeNotifierProvider(create: (context) => PresetsProvider<PresetChat>()),
        ChangeNotifierProvider(create: (context) => PresetsProvider<ExerciseStructure>()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider(context)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: DarkTheme.primary,
            onPrimary: DarkTheme.primary,
            secondary: DarkTheme.secondary,
            onSecondary: DarkTheme.secondary,
            background: DarkTheme.background,
            onBackground: DarkTheme.backgroundDarker,
            error: DarkTheme.error,
            onError: DarkTheme.error,
            surface: DarkTheme.textColor,
            onSurface: DarkTheme.textColor,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return DarkTheme.backgroundDarker;
                }
                return Colors.grey;
              },
            ),
            checkColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return DarkTheme.textColor;
                }
                return Colors.white;
              },
            ),
            side: const BorderSide(color: DarkTheme.backgroundDarker, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white.withOpacity(0.5),
            selectionHandleColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: route,
        home: SplashScreen(),
      ),
    );
  }
}


