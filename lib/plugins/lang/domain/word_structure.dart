const List<String> supportedLanguages= [
  "polish",
  "german",
  "english",
  "spanish",
  "italian",
  "portuguese"
];

@override
WordData createNewWordData(String word, description, lang) {
  DateTime currentDateTime = DateTime.now();
  int initialInterval = 1;
  double initialEaseFactor = 2.5;
  int initialRepetition = 0;

  return WordData(
    id: "",
    word: word,
    lastReview: currentDateTime,
    interval: initialInterval,
    easeFactor: initialEaseFactor,
    repetition: initialRepetition,
    description: description,
    lang: lang,
    notSRS: false,
  );
}

class WordData {
  String id;
  String word;
  DateTime lastReview;
  int interval;
  double easeFactor;
  int repetition;
  String description;
  String lang;
  bool notSRS;

  WordData({
    required this.id,
    required this.word,
    required this.lastReview,
    required this.interval,
    required this.easeFactor,
    required this.repetition,
    required this.description,
    required this.lang,
    required this.notSRS,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'last_review': lastReview.toIso8601String(),
    'interval': interval,
    'ease_factor': easeFactor,
    'repetition': repetition,
    'description': description,
    'lang': lang,
    'notSRS': notSRS,
  };

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      id: json['id'],
      word: json['word'],
      lastReview: DateTime.parse(json['last_review']),
      interval: json['interval'],
      easeFactor: json['ease_factor'],
      repetition: json['repetition'],
      description: json['description'],
      lang: json['lang'],
      notSRS: json['not_srs'],
    );
  }

  DateTime get nextReview => lastReview.add(Duration(days: interval));

  @override
  String toString() {
    return toJson().toString();
  }
}