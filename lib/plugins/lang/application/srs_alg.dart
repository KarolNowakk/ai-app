import 'dart:math';
import 'dart:collection';
import '../domain/word_structure.dart';
import 'package:flutter/material.dart';

class NextWordResult {
  final List<WordData> list;
  final WordData? word;

  NextWordResult({required this.list, required this.word});
}

abstract class RateWordModalInterface {
  Future<void> show(BuildContext context, WordData data);
}

abstract class SRSAlgInterface {
  NextWordResult getNextWord(List<WordData> list);
  WordData updateWordData(WordData wordData, int quality);
}

class SRSAlg implements SRSAlgInterface {
  final double _easeFactorConstant = 0.1;
  final double _easeFactorQualityMultiplier = 0.08;
  final double _easeFactorQualitySquaredMultiplier = 0.02;
  final int _initialInterval = 1;
  final int _secondInterval = 6;

  final SplayTreeSet<WordData> _reviewQueue = SplayTreeSet<WordData>(
        (a, b) => a.nextReview.compareTo(b.nextReview)
  );

  @override
  NextWordResult getNextWord(List<WordData> wordList) {
    List<WordData> list = List.from(wordList);

    list.sort((a, b) => a.nextReview.compareTo(b.nextReview));

    DateTime currentTime = DateTime.now();
    WordData wordData = list.first;

    if (currentTime.isAfter(wordData.nextReview)) {
      list.removeAt(0);

      return NextWordResult(list: list, word: wordData);
    }

    return NextWordResult(list: list, word: null);
  }


  @override
  WordData updateWordData(WordData wordData, int quality) {
    double newEaseFactor = wordData.easeFactor +
        (_easeFactorConstant - (5 - quality) * (_easeFactorQualityMultiplier + (5 - quality) * _easeFactorQualitySquaredMultiplier));
    int newRepetition = max(1, wordData.repetition + 1);
    int newInterval;

    if (quality < 3) {
      newRepetition = 1;
    }

    if (newRepetition == 1) {
      newInterval = _initialInterval;
    } else if (newRepetition == 2) {
      newInterval = _secondInterval;
    } else {
      newInterval = (wordData.interval * newEaseFactor).toInt();
    }

    return WordData(
      id: wordData.id,
      word: wordData.word,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
      easeFactor: newEaseFactor,
      repetition: newRepetition,
      interval: newInterval,
      description: wordData.description,
      lang: wordData.lang,
      notSRS: wordData.notSRS,
      categories: wordData.categories,
    );
  }
}
