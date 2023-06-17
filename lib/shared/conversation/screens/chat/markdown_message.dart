import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MarkdownMessage extends StatefulWidget {
  final String content;
  final bool _isAI;

  const MarkdownMessage.aiMessage({Key? key, required this.content}) : _isAI = true, super(key: key);
  const MarkdownMessage.userMessage({Key? key, required this.content}) : _isAI = false, super(key: key);

  @override
  State<MarkdownMessage> createState() => _MarkdownMessageState();
}

class _MarkdownMessageState extends State<MarkdownMessage> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget._isAI
        ? DarkTheme.background
        : DarkTheme.backgroundDarker;
  }

  @override
  Widget build(BuildContext context) {
    var htmlData = md.markdownToHtml(widget.content);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: color,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
        child: HtmlWidget(
          htmlData,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}