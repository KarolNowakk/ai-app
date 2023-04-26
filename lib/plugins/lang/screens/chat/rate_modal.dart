import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class SRSUpdateInterface {
  WordData updateWordData(WordData wordData, int quality);
}

abstract class WordRepoUpdateInterface {
  Future<void> updateWordDataInList(WordData updatedWordData);
}

class RatingModalController implements RateWordModalInterface{
  late String title;

  RatingModalController();

  @override
  void show(BuildContext context, WordData data) {
    showDialog(
      context: context,
      builder: (_) => RatingModal(
        data: data,
      ),
    );
  }
}

class RatingModal extends StatefulWidget {
  final WordData data;
  final SRSUpdateInterface _srsAlg = KiwiContainer().resolve<SRSUpdateInterface>();
  final WordRepoUpdateInterface _wordRepo = KiwiContainer().resolve<WordRepoUpdateInterface>();

  RatingModal({required this.data});

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  int _rating = 0;

  void _onStarPressed(int rating) {
    setState(() {
      _rating = rating;
    });

    WordData data = widget._srsAlg.updateWordData(widget.data, rating);

    print("wordData");
    print(data);

    widget._wordRepo.updateWordDataInList(data);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate word: ${widget.data.word}'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              _rating >= 1 ? Icons.star : Icons.star_border,
              size: 40.0,
              color: Colors.amber,
            ),
            onPressed: () {
              _onStarPressed(1);
            },
          ),
          IconButton(
            icon: Icon(
              _rating >= 2 ? Icons.star : Icons.star_border,
              size: 40.0,
              color: Colors.amber,
            ),
            onPressed: () {
              _onStarPressed(2);
            },
          ),
          IconButton(
            icon: Icon(
              _rating >= 3 ? Icons.star : Icons.star_border,
              size: 40.0,
              color: Colors.amber,
            ),
            onPressed: () {
              _onStarPressed(3);
            },
          ),
          IconButton(
            icon: Icon(
              _rating >= 4 ? Icons.star : Icons.star_border,
              size: 40.0,
              color: Colors.amber,
            ),
            onPressed: () {
              _onStarPressed(4);
            },
          ),
          IconButton(
            icon: Icon(
              _rating >= 5 ? Icons.star : Icons.star_border,
              size: 40.0,
              color: Colors.amber,
            ),
            onPressed: () {
              _onStarPressed(5);
            },
          ),
        ],
      ),
    );
  }
}
