import 'package:app2/plugins/lang/injection_container.dart';
import 'package:app2/plugins/playground/injection_container.dart';
import 'package:app2/plugins/words_lib/injection_container.dart';
import 'package:app2/screens/auth/splash.dart';
import 'package:app2/screens/auth/start.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:app2/shared/injection_container.dart';
import 'package:app2/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  setupPlayground();
  setupLingApp();
  setupSharedStuff();
  setupWordsLib();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}


