import 'dart:math';
import 'dart:collection';
import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/screens/rate_modal.dart';
import 'package:app2/plugins/lang/screens/save_word_modal.dart';
import 'word_structure.dart';

class SRSAlg implements SRSAlgInterface, SRSUpdateInterface, CreateInitialSRSWordDataInterface {
  final double _easeFactorConstant = 0.1;
  final double _easeFactorQualityMultiplier = 0.08;
  final double _easeFactorQualitySquaredMultiplier = 0.02;
  final int _initialInterval = 1;
  final int _secondInterval = 6;

  SplayTreeSet<WordData> _reviewQueue = SplayTreeSet<WordData>(
        (a, b) => a.nextReview.compareTo(b.nextReview),
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
    } else {
      return null;
    }
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
      word: wordData.word,
      lastReview: DateTime.now(),
      interval: newInterval,
      easeFactor: newEaseFactor,
      repetition: newRepetition,
    );
  }

  @override
  WordData createNewWordData(String word) {
    DateTime currentDateTime = DateTime.now();
    int initialInterval = 1;
    double initialEaseFactor = 2.5;
    int initialRepetition = 0;

    return WordData(
      word: word,
      lastReview: currentDateTime,
      interval: initialInterval,
      easeFactor: initialEaseFactor,
      repetition: initialRepetition,
    );
  }
}
