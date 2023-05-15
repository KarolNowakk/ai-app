import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:app2/shared/file_manager/infrastructure/manager.dart';
import 'package:app2/shared/text_to_speech/domain/tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kiwi/kiwi.dart';

abstract class FileReaderInterface {
  Future<File?> readAudioFromFile(String id);
}

abstract class WebReaderInterface {
  Future<Uint8List?> readAudioFromWeb(String text);
}

class TextToSpeech implements TextToSpeechInterface {
  final FileReaderInterface _fileReader = KiwiContainer().resolve<FileReaderInterface>();
  final WebReaderInterface _webReader = KiwiContainer().resolve<WebReaderInterface>();
  final FileManager _fileManager = FileManager();

  @override
  Future<void> playText(String text) async {
    String id = encode(text);

    File? audioFile = await _fileReader.readAudioFromFile(id);
    final player = AudioPlayer();

    if (audioFile != null) {
      // Play the audio file
      await player.setFilePath(audioFile.path);
    } else {
      Uint8List? audioBytes = await _webReader.readAudioFromWeb(text);
      if (audioBytes == null) {
        throw Exception("File from web is null");
      }

      await _fileManager.saveFileToPath(audioBytes, "$id.mp3");
      File? audioFile = await _fileReader.readAudioFromFile(id);

      if (audioFile == null) {
        throw Exception("Reading saved file failed");
      }

      await player.setFilePath(audioFile.path);
    }

    await player.play();
  }

  String encode(String input) {
    var bytes = utf8.encode(input); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}