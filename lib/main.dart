import 'package:app2/plugins/lang/injection_container.dart';
import 'package:app2/plugins/words_lib/injection_container.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  setupLingApp();
  setupWordsLib();

  requestPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        textTheme: TextTheme(
          displayLarge: DarkTheme.headlineTextStyle,
          displaySmall: DarkTheme.buttonTextStyle,
          bodyLarge: DarkTheme.bodyTextStyle,
        ),
        // textButtonTheme: TextButtonThemeData(
        //   style: TextButton.styleFrom(
        //     side: const BorderSide(color: DarkTheme.backgroundDarker, width: 2),
        //     padding: EdgeInsets.zero,
        //     textStyle: const TextStyle(
        //       fontSize: 16,
        //       color: DarkTheme.textColor,
        //     ),
        //   )
        // ),
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
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}


Future<void> requestPermissions() async {
  await Permission.microphone.request();
  await Permission.storage.request();
}