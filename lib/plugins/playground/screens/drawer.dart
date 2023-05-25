import 'package:app2/shared/elements/text_field.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/plugins/playground/screens/model_dropdown.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class OptionsDrawer extends StatefulWidget {
  final TextEditingController _titleController = TextEditingController();
  double _topPValue = 0.5;
  double _tempValue = 0.5;
  String _model = AIConversation.gpt4;
  List<Widget> additionalElements;

  OptionsDrawer({super.key, List<Widget>? additionalElements})
      : additionalElements = additionalElements ?? [];

  void _onDropdownChange(String value) {
    _model = value;
  }

  void getData(void Function(String, String, double, double) callback) {
    callback(_titleController.text, _model, _topPValue, _tempValue);
  }

  void setData(String text, model, double topP, double temp) {
    _titleController.text = text;
    _model = model;
    _topPValue = topP;
    _tempValue = temp;
  }

  @override
  State<OptionsDrawer> createState() => _OptionsDrawerState();
}

class _OptionsDrawerState extends State<OptionsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 50),
            ModelDropdown(onChange: widget._onDropdownChange, value: widget._model),
            const SizedBox(height: 20),
            DefaultTextWidget(
                controller: widget._titleController,
                hint: "Title...",
            ),
            const SizedBox(height: 20),
            Text(
              "Top P        ${widget._topPValue}",
              style: const TextStyle(
                color: DarkTheme.textColor,
              ),
            ),
            Slider(
              value: widget._topPValue,
              min: 0,
              max: 1,
              activeColor: DarkTheme.primary,
              inactiveColor: DarkTheme.primary,
              onChanged: (newValue) {
                setState(() {
                  widget._topPValue = double.parse(newValue.toStringAsFixed(2));
                });
              },
            ),
            Text(
              'Temperature        ${widget._tempValue}',
              style: const TextStyle(
                color: DarkTheme.textColor,
              ),
            ),
            Slider(
              value: widget._tempValue,
              min: 0,
              max: 1,
              activeColor: DarkTheme.primary,
              inactiveColor: DarkTheme.primary,
              onChanged: (newValue) {
                setState(() {
                  widget._tempValue = double.parse(newValue.toStringAsFixed(2));
                });
              },
            ),
            ...widget.additionalElements,
          ],
        ),
      ),
    );
  }
}
