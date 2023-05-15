import 'package:app2/screens/auth/start.dart';
import 'package:app2/screens/main.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthServiceInterface _auth = KiwiContainer().resolve<AuthServiceInterface>();

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    print("checkUserStatus");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_auth.isUserLoggedIn()) {
        print("isUserLoggedIn");

        Navigator.pushNamedAndRemoveUntil(
            context, ExerciseHomeScreen.route, (Route<dynamic> route) => false);
      } else {
        print("NOTisUserLoggedIn");

        Navigator.pushNamedAndRemoveUntil(
            context, StartScreen.route, (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
