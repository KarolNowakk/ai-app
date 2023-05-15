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
    'id': id,
    'word': word,
    'next_review': nextReview.toIso8601String(),
    'ease_factor': easeFactor,
    'repetition': repetition,
    'interval': interval,
    'description': description,
    'lang': lang,
    'not_srs': notSRS,
  };

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      id: json['id'],
      word: json['word'],
      nextReview: DateTime.parse(json['next_review']),
      easeFactor: json['ease_factor'],
      repetition: json['repetition'],
      interval: json['interval'],
      description: json['description'] ?? "",
      lang: json['lang'],
      notSRS: json['not_srs'],
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}