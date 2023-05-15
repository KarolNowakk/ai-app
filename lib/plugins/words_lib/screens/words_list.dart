import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:app2/plugins/words_lib/screens/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';

class WordsListScreen extends StatefulWidget {
  static const String route = "words_list";
  String lang;

  WordsListScreen({required this.lang});

  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();

  @override
  _WordsListScreenState createState() => _WordsListScreenState();
}

class _WordsListScreenState extends State<WordsListScreen> {
  final List<WordData> _items = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadExercises(String lang) async {
    if (_items.isNotEmpty) return;

    List<WordData> wordsList = await widget._wordsRepo.getAllWords(lang);

    wordsList.forEach((word) {
      setState(() {
        _items.add(word);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadExercises(widget.lang);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('List of words in ${widget.lang}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _buildListTiles(),
      ),
    );
  }

  Widget _buildListTiles() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return WordTile(data: item);
      },
    );
  }
}