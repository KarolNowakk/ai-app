import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class CartModalController {
  @override
  void show(BuildContext context, List<WordData> list) {
    showDialog( context: context, builder: (context) => CartModal(data: list));
  }
}

class CartModal extends StatefulWidget {
  final List<WordData> data;

  const CartModal({super.key, required this.data});

  @override
  State<CartModal> createState() => _CartModalState();
}

class _CartModalState extends State<CartModal> {
  int _currentIndex = 0;

  void nextString() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.data.length;
    });
  }

  void previousString() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.data.length) % widget.data.length;
    });
  }

  bool isManyWords() {
    return widget.data.length > 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.all(1.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isManyWords() ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: DarkTheme.secondary),
                onPressed: () {
                  previousString();
                },
              ) : const SizedBox.shrink(),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      widget.data[_currentIndex].word,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.data[_currentIndex].description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              isManyWords() ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: DarkTheme.secondary),
                onPressed: () {
                  nextString();
                },
              ) : const SizedBox.shrink(),
            ],
          ),
        ],
      ),

    );
  }
}