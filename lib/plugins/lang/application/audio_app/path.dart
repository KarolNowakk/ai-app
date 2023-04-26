import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioFile {
  Future<String> path() async {
    final directory = await getExternalStorageDirectory();
    String path = directory?.path ?? "";
    return '$path/record.wav';
  }

  Future<File?> file() async {
    try {
      String outputPath = await path();
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

}