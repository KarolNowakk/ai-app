import 'dart:convert';
import 'package:app2/shared/auth/application/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> migrate() async {
  const String collectionName = 'exercises';
  await migrateDataToFirestore(collectionName);
}

Future<void> migrateDataToFirestore(String collectionName) async {
  final CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection(collectionName);
  final List<dynamic> jsonData = await _loadJsonData();

  print("jsonData.length()");
  print(jsonData.length);
  // return;

  for (final record in jsonData) {
    if (record is Map<String, dynamic>) {
      record["user_id"] = AuthService().getUser().id;
      record.remove("id");

      print(record);
      // return;
      // await collection.add(record);
    }
  }

  print('Migration completed successfully.');
}

Future<List<dynamic>> _loadJsonData() async{
  String jsonString = await rootBundle.loadString('assets/words.json');

  return jsonDecode(jsonString);
}
