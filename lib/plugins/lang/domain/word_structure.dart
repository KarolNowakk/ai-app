class WordData {
  int id;
  String word;
  DateTime lastReview;
  int interval;
  double easeFactor;
  int repetition;

  WordData({
    required this.id,
    required this.word,
    required this.lastReview,
    required this.interval,
    required this.easeFactor,
    required this.repetition,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'last_review': lastReview.toIso8601String(),
    'interval': interval,
    'ease_factor': easeFactor,
    'repetition': repetition,
  };

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      id: json['id'],
      word: json['word'],
      lastReview: DateTime.parse(json['last_review']),
      interval: json['interval'],
      easeFactor: json['ease_factor'],
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