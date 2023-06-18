class Category {
  String id;
  String name;
  String lang;
  bool isUserCreated;

  Category({required this.name, required this.lang, required this.id, required this.isUserCreated});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lang': lang,
      'is_user_created': isUserCreated,
    };
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      lang: json['lang'],
      isUserCreated: json['is_user_created'] ?? false,
    );
  }
}