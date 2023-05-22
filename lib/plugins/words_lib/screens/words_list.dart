import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:app2/plugins/words_lib/infrastructure/words_repo.dart';
import 'package:app2/plugins/words_lib/screens/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';

class WordsListScreen extends StatefulWidget {
  static const String route = "words_list";
  String lang;

  WordsListScreen({required this.lang});

  final WordsRepo _wordsRepo = KiwiContainer().resolve<WordsRepo>();

  @override
  _WordsListScreenState createState() => _WordsListScreenState();
}

class _WordsListScreenState extends State<WordsListScreen> {
  final ScrollController _controller = ScrollController();
  final evenItems = <Widget>[];
  final oddItems = <Widget>[];

  @override
  void initState() {
    super.initState();
    _loadExercises(widget.lang);
  }

  Future<void> _loadExercises(String lang) async {
    List<WordData> wordsList = await widget._wordsRepo.getAllWords(lang, null);

    for (var i = 0; i < wordsList.length; i++) {
      WordTile tile = WordTile(data: wordsList[i]);

      if (i % 2 == 0) {
        setState(() {
          evenItems.add(tile);
        });
        continue;
      }
      setState(() {
        oddItems.add(tile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: _buildGridTiles(),
      ),
    );
  }

  Widget _buildGridTiles() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            controller: _controller,
            children: evenItems,
          ),
        ),
        Expanded(
          child: ListView(
            controller: _controller,
            children: oddItems,
          ),
        ),
      ],
    );
  }
}