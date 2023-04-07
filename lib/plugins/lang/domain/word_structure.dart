class WordData {
  String word;
  DateTime lastReview;
  int interval;
  double easeFactor;
  int repetition;

  WordData({
    required this.word,
    required this.lastReview,
    required this.interval,
    required this.easeFactor,
    required this.repetition,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'lastReview': lastReview.toIso8601String(),
    'interval': interval,
    'easeFactor': easeFactor,
    'repetition': repetition,
  };

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      word: json['word'],
      lastReview: DateTime.parse(json['lastReview']),
      interval: json['interval'],
      easeFactor: json['easeFactor'],
      repetition: json['repetition'],
    );
  }

  DateTime get nextReview => lastReview.add(Duration(days: interval));

  @override
  String toString() {
    return toJson().toString();
  }
}

// {
//   {
//     "word": "immer",
//     "lastReview": "2023-04-04T23:59:00:00Z",
//     "interval": 6,
//     "easeFactor": 0.5,
//     "repetition": 12,
//   },
//   {
//   "word": "nie",
//   "lastReview": "2023-04-04T23:59:00:00Z",
//   "interval": 6,
//   "easeFactor": 0.5,
//   "repetition": 12,
//   }
// }