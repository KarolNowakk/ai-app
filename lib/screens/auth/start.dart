import 'package:app2/screens/auth/login.dart';
import 'package:app2/screens/auth/register.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  static const route = "start";

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfinityButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.route);
                  },
                  text: 'Login',
                ),
                const SizedBox(height: 16.0),
                InfinityButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.route);
                  },
                  text: 'Register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
