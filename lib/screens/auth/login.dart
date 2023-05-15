import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/shared/elements/password_text_field.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const route = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      );

      print('User logged in: ${userCredential.user!.uid}');
      Navigator.pushNamed(context, "/");

    } on FirebaseAuthException catch (e) {
      setState(() {
         _errorMessage = e.toString();
      });

      print(_errorMessage);
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
                    await login();
                    // progress?.dismiss();
                  },
                  text: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
