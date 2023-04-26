import 'package:app2/extensions/string.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/words_lib/screens/words_list.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class LangSelectorScreen extends StatefulWidget {
  static const String route = "lang_selector";

  @override
  _LangSelectorScreenState createState() => _LangSelectorScreenState();
}

class _LangSelectorScreenState extends State<LangSelectorScreen> {
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadLangs();
  }

  Future<void> _loadLangs() async {
    supportedLanguages.forEach((element) {
      setState(() {
        _items.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Choose your exercise.'),
      ),
      body: _buildListTiles(),
    );
  }

  Widget _buildListTiles() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildListItem(item, index);
      },
    );
  }

  Widget _buildListItem(
      String item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(-3, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    WordsListScreen.route,
                    arguments: item,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    item.capitalizeFirstLetter(),
                    style: const TextStyle(
                        color: DarkTheme.textColor, fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}