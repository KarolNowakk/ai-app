import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/words_lib/application/words_repo.dart';
import 'package:app2/plugins/words_lib/screens/stream_details.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class WordTile extends StatefulWidget {
  final WordData data;


  WordTile({required this.data});

  @override
  _WordTileState createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  bool _isSelected = false;

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.symmetric(
            vertical: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: 2.0,
            ),
            horizontal: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: 2.0,
            ),
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleSelection,
              child: WordPreview(isSelected: _isSelected, word: widget.data.word),
            ),
            _isSelected ? WordDetails(data: widget.data) : const SizedBox.shrink(),
          ],
        )
      ),
    );
  }
}

class WordPreview extends StatelessWidget {
  const WordPreview({
    super.key,
    required bool isSelected,
    required this.word,
  }) : _isSelected = isSelected;

  final bool _isSelected;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _isSelected ? Icons.expand_less : Icons.expand_more,
          ),
          const SizedBox(width: 20),
          Text(
            word,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class WordDetails extends StatefulWidget {
  final WordData data;
  final WordsRepoInterface _repo = KiwiContainer().resolve<WordsRepoInterface>();

  WordDetails({required this.data});

  @override
  _WordDetailsState createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _descriptionController.text = widget.data.description;
      _titleController.text = widget.data.word;
      _isChecked = widget.data.notSRS;
    });
  }

  void _submit() {
    WordData updatedWordData = WordData(
        id: widget.data.id,
        word: _titleController.text != "" ? _titleController.text : widget.data.word,
        nextReview: widget.data.nextReview,
        interval: widget.data.interval,
        easeFactor: widget.data.easeFactor,
        repetition: widget.data.repetition,
        description: _descriptionController.text,
        lang: widget.data.lang,
        notSRS: _isChecked,
    );

    widget._repo.updateWord(updatedWordData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 16.0, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamDetails(data: widget.data),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 2, color: Theme.of(context).colorScheme.onBackground),
            ),
            // color: Theme.of(context).colorScheme.onBackground,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: null,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Description here...",
                      labelText: null,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: const Text('Skip in exercises'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _submit,
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}