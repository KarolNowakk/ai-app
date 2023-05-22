import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/words_lib/infrastructure/words_repo.dart';
import 'package:app2/theme.dart';
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
          color: DarkTheme.backgroundDarker,
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
      padding: const EdgeInsets.all(3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  final WordsRepo _repo = KiwiContainer().resolve<WordsRepo>();

  WordDetails({required this.data});

  @override
  _WordDetailsState createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _titleFocus = FocusNode();
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

    _descriptionFocus.addListener(() {
      if (!_descriptionFocus.hasFocus) {
        print("-----------------------------------");
        print("------------------------------------");
        widget._repo
            .updateDescription(widget.data.id, _descriptionController.text);
      }
    });

    _titleFocus.addListener(() {
      if (!_titleFocus.hasFocus) {
        widget._repo
            .updateWordText(widget.data.id, _titleController.text);
      }
    });
  }

  // void _submit() {
  //   WordData updatedWordData = WordData(
  //       id: widget.data.id,
  //       word: _titleController.text != "" ? _titleController.text : widget.data.word,
  //       nextReview: widget.data.nextReview,
  //       interval: widget.data.interval,
  //       easeFactor: widget.data.easeFactor,
  //       repetition: widget.data.repetition,
  //       description: _descriptionController.text,
  //       lang: widget.data.lang,
  //       notSRS: _isChecked,
  //   );
  //
  //   widget._repo.updateWord(updatedWordData);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 2.0, right: 2, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                children: [
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
                    onEditingComplete: () => {

                    },
                  ),
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

                          widget._repo.notSRS(widget.data.id, _isChecked);
                        },
                        child: const Text('Skip in exercise'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}