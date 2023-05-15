import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class LangDropdown extends StatefulWidget {
  Function(String value) onChange;
  String selectedLang;

  LangDropdown({required this.onChange, required this.selectedLang});

  @override
  State<LangDropdown> createState() => _LangDropdownState();
}

class _LangDropdownState extends State<LangDropdown> {
  List<DropdownMenuItem<String>> listOfLanguages = [];

  @override
  void initState() {
    super.initState();

    supportedLanguages.forEach((e) {
      DropdownMenuItem<String> v =
      DropdownMenuItem<String>(value: e, child: Text(e));
      listOfLanguages.add(v);
    });
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
      value: widget.selectedLang,
      isExpanded: true,
      items: listOfLanguages,
      onChanged: (value) {
        setState(() {
          widget.selectedLang = value ?? "polish";
          widget.onChange(widget.selectedLang);
        });
      },
    );
  }
}