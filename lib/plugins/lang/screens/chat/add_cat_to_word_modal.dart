import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/category.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class AddCategoryToWordModalController {
  @override
  void show(BuildContext context, List<WordData> list, List<Category> catList) {
    showDialog(context: context, builder: (context) => AddCategoryToWordModal(data: list, catData: catList));
  }
}

class AddCategoryToWordModal extends StatefulWidget {
  final List<WordData> data;
  final List<Category> catData;

  const AddCategoryToWordModal({super.key, required this.data, required this.catData});

  @override
  State<AddCategoryToWordModal> createState() => _AddCategoryToWordModalState();
}

class _AddCategoryToWordModalState extends State<AddCategoryToWordModal> {
  final WordsRepoInterface _wordsRepo = KiwiContainer().resolve<WordsRepoInterface>();
  String _dropdownValue = "";
  int _currentIndex = 0;
  final List<String> _cats = [];

  @override
  void initState() {
    super.initState();

    _dropdownValue = widget.catData[0].name;
    _currentCategoriesForAWord(0);
  }

  void _currentCategoriesForAWord(int index) {
    _cats.clear();
    _cats.addAll(widget.data[index].categories);
  }

  void nextString() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.data.length;
      _currentCategoriesForAWord(_currentIndex);
    });
  }

  void previousString() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.data.length) % widget.data.length;
      _currentCategoriesForAWord(_currentIndex);
    });
  }

  save() {
    WordData data = widget.data[_currentIndex];

    data.categories.clear();
    data.categories.addAll(_cats);

    _wordsRepo.updateCategories(data);
  }

  bool isManyWords() {
    return widget.data.length > 1;
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isManyWords() ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  previousString();
                },
              ) : const SizedBox.shrink(),
              Flexible(
                child: Column(
                  children: [
                    Text(widget.data[_currentIndex].word, style: const TextStyle(fontSize: 20)),
                    dropDown(context),
                    Container(
                      height: 200,
                      width: 200,// Wrapping ListView.builder with Flexible
                      child: ListView.builder(
                        itemCount: _cats.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(_cats[index], style: const TextStyle(color: DarkTheme.textColor)),
                            ),
                            onLongPress: () {
                              setState(() {
                                _cats.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    InfinityButton(
                        text: "Save",
                        onPressed: () {
                          save();
                          Navigator.pop(context);
                        }
                    ),
                  ],
                ),
              ),
              isManyWords() ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
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

  @override
  Widget dropDown(BuildContext context) {
    return DropdownButton<String>(
      value: _dropdownValue,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: DarkTheme.textColor),
      underline: Container(
        height: 2,
        color: DarkTheme.textColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _dropdownValue = newValue!;
          if (_cats.contains(newValue)) return;

          _cats.add(newValue);
        });
      },
      items: widget.catData.map<DropdownMenuItem<String>>((Category value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}