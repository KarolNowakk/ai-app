import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class ModelDropdown extends StatefulWidget {
  Function(String value) onChange;
  String? value;

  ModelDropdown({required this.onChange, this.value});

  @override
  State<ModelDropdown> createState() => _ModelDropdownState();
}

class _ModelDropdownState extends State<ModelDropdown> {
  List<DropdownMenuItem<String>> listOfModels = [];

  @override
  void initState() {
    super.initState();

    DropdownMenuItem<String> gpt3 = const DropdownMenuItem<String>(
        value: AIConversation.gpt3turbo,
        child: Text("GPT-3"),
    );

    DropdownMenuItem<String> gpt4 = const DropdownMenuItem<String>(
      value: AIConversation.gpt4,
      child: Text("GPT-4"),
    );

    listOfModels.add(gpt3);
    listOfModels.add(gpt4);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: DarkTheme.textColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: DarkTheme.textColor,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: DarkTheme.textColor,
        fontSize: 17,
      ),
      value: widget.value,
      isExpanded: true,
      items: listOfModels,
      onChanged: (value) {
        setState(() {
          widget.value = value;
          widget.onChange(value ?? "");
        });
      },
    );
  }
}