import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Message extends StatefulWidget {
  final String content;
  final bool _isAI;

  const Message.aiMessage({Key? key, required this.content}) : _isAI = true, super(key: key);
  const Message.userMessage({Key? key, required this.content}) : _isAI = false, super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
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
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
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


// import 'package:app2/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
//
// class Message extends StatefulWidget{
//   final String content;
//   final bool _isAI;
//
//   const Message.aiMessage({super.key, required this.content}) : _isAI = true;
//   const Message.userMessage({super.key, required this.content}) : _isAI = false;
//
//   @override
//   _MessageState createState() => _MessageState();
// }
//
// class _MessageState extends State<Message> {
//   late Color color;
//
//   final MarkdownStyleSheet customStyleSheet = MarkdownStyleSheet(
//     h1: const TextStyle(fontSize: 24),
//     h2: const TextStyle(fontSize: 20),
//     p: const TextStyle(fontSize: 16),
//     a: const TextStyle(color: Colors.blue),
//   );
//
//
//   @override
//   void initState() {
//     super.initState();
//     color = widget._isAI
//         ? DarkTheme.primary
//         : DarkTheme.secondary;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       decoration: BoxDecoration(
//         color: color,
//       ),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
//         child: SelectableText(
//           widget.content,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.normal,
//             fontSize: 16,
//             decoration: TextDecoration.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
