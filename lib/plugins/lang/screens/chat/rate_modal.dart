import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class RatingModalController implements RateWordModalInterface{
  late String title;

  RatingModalController();

  @override
  Future<void> show(BuildContext context, WordData data) async {
    await showDialog(
      context: context,
      builder: (_) => RatingModal(
        data: data,
      ),
    );
  }
}

class RatingModal extends StatefulWidget {
  final WordData data;
  final SRSAlgInterface _srsAlg = KiwiContainer().resolve<SRSAlgInterface>();
  final WordsRepoInterface _wordRepo = KiwiContainer().resolve<WordsRepoInterface>();

  RatingModal({required this.data});

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  int _rating = 0;
  bool _doNotShowAnymore = false;

  void _onStarPressed(int rating) {
    setState(() {
      _rating = rating;
    });

    WordData data = widget._srsAlg.updateWordData(widget.data, rating);
    data.notSRS = _doNotShowAnymore;

    widget._wordRepo.updateWordDataInList(data);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate word: ${widget.data.word}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(5, (index) => buildStarButton(index + 1)),
          ),
          CheckboxListTile(
            title: const Text("Don't show anymore"),
            value: _doNotShowAnymore,
            onChanged: (bool? newValue) {
              setState(() {
                _doNotShowAnymore = newValue ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildStarButton(int starNumber) {
    return IconButton(
      icon: Icon(
        _rating >= starNumber ? Icons.star : Icons.star_border,
        size: 40.0,
        color: Colors.amber,
      ),
      onPressed: () {
        _onStarPressed(starNumber);
      },
    );
  }
}
