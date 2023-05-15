import 'dart:math';
import 'dart:collection';
import '../domain/word_structure.dart';
import 'package:flutter/material.dart';

abstract class RateWordModalInterface {
  void show(BuildContext context, WordData data);
}

abstract class SRSAlgInterface {
  void setAll(List<WordData> list);
  WordData? getNextWord();
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
  void setAll(List<WordData> list) {
    _reviewQueue.addAll(list);
  }

  @override
  WordData? getNextWord() {
    if (_reviewQueue.isEmpty) return null;

    DateTime currentTime = DateTime.now();
    WordData wordData = _reviewQueue.first;

    if (currentTime.isAfter(wordData.nextReview)) {
      _reviewQueue.remove(wordData);
      return wordData;
    }

    return null;
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
    );
  }
}
