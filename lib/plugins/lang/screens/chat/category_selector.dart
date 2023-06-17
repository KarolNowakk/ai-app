import 'package:app2/plugins/lang/domain/category.dart';
import 'package:app2/plugins/lang/interfaces/exercises_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class CategorySelector extends StatefulWidget {
  final RateWordModalInterface _rateWordModal = KiwiContainer().resolve<RateWordModalInterface>();

  CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 50,
        ),
        child: DropdownSearch<String>(
            items: context.watch<ExerciseProvider>().categoryList,
            onChanged: (String? value) {
              if (value == null || value == "") return;

              context.read<ExerciseProvider>().loadNewWords(value!);
            },
            selectedItem: "My own"
        ),
      ),
    );
  }
}