const List<String> supportedLanguages= [
  "polish",
  "german",
  "english",
  "spanish",
  "italian",
  "portuguese",
  "french",
];

class WordData {
  static const String idJson = 'id';
  static const String wordJson = 'word';
  static const String nextReviewJson = 'next_review';
  static const String easeFactorJson = 'ease_factor';
  static const String repetitionJson = 'repetition';
  static const String intervalJson = 'interval';
  static const String descriptionJson = 'description';
  static const String langJson = 'lang';
  static const String notSRSJson = 'not_srs';

  String id;
  String word;
  DateTime nextReview;
  double easeFactor;
  int interval;
  int repetition;
  String description;
  String lang;
  bool notSRS;

  WordData({
    required this.id,
    required this.word,
    required this.nextReview,
    required this.easeFactor,
    required this.repetition,
    required this.interval,
    required this.description,
    required this.lang,
    required this.notSRS,
  });

  static WordData createNewWordData(String word, description, lang) {
    double initialEaseFactor = 2.5;
    int initialRepetition = 0;

    return WordData(
      id: "",
      word: word,
      interval: 1,
      nextReview: DateTime.now().add(const Duration(days: 1)),
      easeFactor: initialEaseFactor,
      repetition: initialRepetition,
      description: description,
      lang: lang,
      notSRS: false,
    );
  }

  Map<String, dynamic> toJson() => {
    idJson: id,
    wordJson: word,
    nextReviewJson: nextReview.toIso8601String(),
    easeFactorJson: easeFactor,
    repetitionJson: repetition,
    intervalJson: interval,
    descriptionJson: description,
    langJson: lang,
    notSRSJson: notSRS,
  };

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      id: json[idJson],
      word: json[wordJson],
      nextReview: DateTime.parse(json[nextReviewJson]),
      easeFactor: json[easeFactorJson],
      repetition: json[repetitionJson],
      interval: json[intervalJson],
      description: json[descriptionJson] ?? "",
      lang: json[langJson],
      notSRS: json[notSRSJson],
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}