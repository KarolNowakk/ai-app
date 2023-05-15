import 'dart:io';
import 'package:app2/shared/file_manager/infrastructure/manager.dart';
import 'package:app2/shared/text_to_speech/application/tts.dart';
import 'dart:async';

class FileReaderImpl extends FileReaderInterface {
  final FileManager _manager = FileManager();

  @override
  Future<File?> readAudioFromFile(String id) async {
    final filePath = '$id.mp3';

    final file = await _manager.file(filePath);

    if (file == null) {
      return Future.value(null);
    }

    return Future.value(file);
  }
}