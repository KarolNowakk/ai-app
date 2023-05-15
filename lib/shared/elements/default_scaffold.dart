import 'package:flutter/material.dart';

class DefaultScaffold extends StatelessWidget {
  List<Widget>? actions;
  Widget body;
  Widget? drawer;

  DefaultScaffold({super.key,
    this.actions,
    this.drawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: actions,
      ),
      endDrawer: drawer,
      body: body,
    );
  }
}