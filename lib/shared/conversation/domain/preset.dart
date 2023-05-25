abstract class Preset {
  static const String jsonId = "id";
  static const String jsonTitle = "title";

  String id;
  String title;

  Preset({this.id = "", this.title = ""});

  // String collectionName();

  Map<String, dynamic> toJson() {
    return {jsonId: id, jsonTitle: title};
  }

  factory Preset.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}