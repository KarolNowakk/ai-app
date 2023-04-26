import 'dart:developer';
import 'dart:io';

import 'package:app2/plugins/lang/application/audio_app/path.dart';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:dart_openai/openai.dart';
import 'package:kiwi/kiwi.dart';

abstract class SpeechToTextInterface {
  Future<String> getTranscription();
}

class SpeechToText implements SpeechToTextInterface {
  final AudioFile _fileProvider = AudioFile();
  final Config _config = KiwiContainer().resolve<Config>();

  @override
  Future<String> getTranscription() async {
    OpenAI.apiKey = _config.getEntry(openAIKey);

    log("--------------- Starting transcription ---------------");
    File? file = await _fileProvider.file();

    if (file == null) {
      log("File not found");
      return "File not found";
    }
    log('File path: ${file.path}');

    try {
      OpenAIAudioModel transcription = await OpenAI.instance.audio.createTranscription(
        file: file,
        model: "whisper-1",
        responseFormat: OpenAIAudioResponseFormat.json,
      );
      log("------------------ Transcription completed ------------------");

      log('Transcription: ${transcription.text}');

      return transcription.text;
    } catch (e) {
      log('Error during transcription: $e');
      return 'Error during transcription';
    }
  }
}


