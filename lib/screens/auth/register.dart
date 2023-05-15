import 'package:app2/screens/main.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/password_text_field.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const route = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repeatPassController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> register() async {
    if (_passController.text != _repeatPassController.text) {
      setState(() {
        _errorMessage = "Passwords don't match.";
      });

      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      );

      print('User registered: ${userCredential.user!.uid}');
      Navigator.pushNamed(context, ExerciseHomeScreen.route);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'The account already exists for that email.';
        } else {
          _errorMessage = e.toString();
        }

        print(_errorMessage);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

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
                const Text(
                  'Email:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10.0),
                DefaultTextWidget(
                  controller: _emailController,
                  hint: 'example@example.com',
                ),
                const SizedBox(height: 20.0),
                const Text('Password:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                DefaultPasswordTextWidget(
                  controller: _passController,
                  hint: '...',
                ),
                const SizedBox(height: 20.0),
                const Text('Repeat Password:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10.0),
                DefaultPasswordTextWidget(
                  controller: _repeatPassController,
                  hint: '...',
                ),
                const SizedBox(height: 20.0),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                const SizedBox(height: 10.0),
                InfinityButton(
                  onPressed: () async {
                    // final progress = ProgressHUD.of(context);
                    // progress?.showWithText('Registering...');
                    await register();
                    // progress?.dismiss();
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
