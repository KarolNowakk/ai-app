import 'dart:developer';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManager {
  Future<String> path(String fileName) async {
    Directory? directory;

    try {
      directory = await getExternalStorageDirectory();
    } catch (e) {
      directory = await getApplicationDocumentsDirectory();
    }

    String path = directory?.path ?? "";
    return '$path/$fileName';
  }

  Future<File?> file(String fileName) async {
    try {
      String outputPath = await path(fileName);
      File audioFile = File(outputPath);

      if (await audioFile.exists()) {
        return audioFile;
      }

      log('Audio file not found: $outputPath');
      return null;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<void> saveFileToPath(Uint8List bytesToSave, String fileName) async {
    String outputPath = await path(fileName);
    File outputFile = File(outputPath);

    try {
      await outputFile.writeAsBytes(bytesToSave);
      log('File saved successfully: $outputPath');
    } catch (e) {
      log('Error saving file: $e');
    }
  }
}