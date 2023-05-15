import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class StreamMessage extends StatefulWidget {
  static const String roleAssistant = "assistant";
  static const String roleUser = "user";

  String? text;
  String displayText = "";
  final Stream<String>? textStream;
  bool isStreamDone = false;

  int index;
  final Function(int index) delete;
  String role = "assistant";
  final TextEditingController _msgTextController = TextEditingController();

  StreamMessage.text(
      {super.key,
      required this.text,
      required this.role,
      required this.delete,
      required this.index})
      : textStream = null;

  StreamMessage.stream(
      {super.key,
      required this.textStream,
      required this.role,
      required this.delete,
      required this.index})
      : text = null;

  void getData(void Function(String text, String dropdownValue) callback) {
    callback(_msgTextController.text, role);
  }

  @override
  _StreamMessageState createState() => _StreamMessageState();
}

class _StreamMessageState extends State<StreamMessage> {
  late Color _color = DarkTheme.background;

  void switchRoles() {
    setState(() {
      widget.role = widget.role == StreamMessage.roleUser
          ? StreamMessage.roleAssistant
          : StreamMessage.roleUser;
    });
  }

  @override
  void initState() {
    super.initState();

    print("widget.text");
    print(widget.text);

    if (widget.text != null) {
      widget.displayText = widget.text!;
      widget._msgTextController.text = widget.text!;
      return;
    }

    if (widget.isStreamDone && widget.displayText != "") {
      return;
    }

    try {
      _listenToStream();
    } catch (e) {
      widget.displayText = "There was an error on stream: ${e.toString()}";
      _color = Colors.redAccent;
    }
  }

  void _listenToStream() {
    log(widget.textStream.toString());
    if (widget.textStream != null) {
      widget.textStream!.listen((data) {
        setState(() {
          widget.displayText += data;
          widget._msgTextController.text += data;
        });
      }, onDone: () {
        widget.isStreamDone = true;
      }, onError: (error) {
        log('Error: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _color = DarkTheme.backgroundDarker;
        });
      },
      onExit: (event) {
        setState(() {
          _color = DarkTheme.background;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _color,
          border: const Border(
              bottom: BorderSide(width: 1.0, color: DarkTheme.backgroundDarker)),
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(width: 2.0,color: DarkTheme.primary)),
              ),
              width: 80,
              child: TextButton(
                onPressed: switchRoles,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: const TextStyle(
                        fontSize: 13,
                        color: DarkTheme.textColor,
                      ),
                      widget.role),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                // onChanged: widget._msgTextController,
                maxLines: null,
                controller: widget._msgTextController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  decoration: TextDecoration.none,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.white,
                onPressed: () => {
                  widget.delete(widget.index),
                }),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
