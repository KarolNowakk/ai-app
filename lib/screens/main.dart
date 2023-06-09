import 'package:app2/plugins/image_to_text/screens/main.dart';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/screens/exercise/selector.dart';
import 'package:app2/plugins/words_lib/screens/lang_select.dart';
import 'package:app2/shared/conversation/screens/presets/select_screen.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/macos/file_access.dart';
import 'package:app2/macos/microphone_acces.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {
  // Request microphone access permission on macOS
  if (Theme.of(context).platform == TargetPlatform.macOS) {
    await MicrophoneAccessMacOS.requestPermission();
    await FileAccessMacOS.requestPermission();
  } else {
    // Request permissions for other platforms
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }
}

class ExerciseHomeScreen extends StatefulWidget {
  static const route = "home";
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
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadConfig();
    requestPermissions(context);

    return Scaffold(
      backgroundColor: DarkTheme.background,
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
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
        color: Theme.of(context).colorScheme.background,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      route: ExerciseSelectorScreen.route,
                      text: 'Language Exercises',
                      icon: Icon(
                        Icons.school_outlined,
                        color: DarkTheme.textColor,
                        size: 70,
                      ),
                    ),
                  ),
                  Expanded(
                    child: OptionButton(
                      route: '/translator',
                      text: 'Translate',
                      icon: Icon(
                        Icons.translate,
                        color: DarkTheme.textColor,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      route: LiveTextTranslation.route,
                      text: 'Live text translation',
                      icon: Icon(
                        Icons.list_alt_rounded,
                        color: DarkTheme.textColor,
                        size: 70,
                      ),
                    ),
                  ),
                  Expanded(
                    child: OptionButton(
                      route: PresetsSelectorScreen.route,
                      text: 'Chat',
                      icon: Icon(
                        Icons.chat,
                        color: DarkTheme.textColor,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String route;
  final Widget icon;

  const OptionButton({
    super.key,
    required this.text,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
          ),
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: DarkTheme.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
