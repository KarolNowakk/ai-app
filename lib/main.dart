import 'package:app2/plugins/lang/injection_container.dart';
import 'package:app2/plugins/lang/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  setupLingApp();
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
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}