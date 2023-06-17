class Category {
  String id;
  String name;
  String lang;

  Category({required this.name, required this.lang, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lang': lang,
    };
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      lang: json['lang'],
    );
  }
}