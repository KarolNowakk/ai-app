import 'dart:async';
import 'dart:developer';
import 'package:app2/plugins/lang/application/audio_app/path.dart';
import 'package:flutter_sound/flutter_sound.dart';

abstract class AudioRecorderInterface {
  Future<void> startRecording();
  Future<void> stopRecording();
}

class AudioRecorder implements AudioRecorderInterface{
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioFile _path = AudioFile();

  @override
  Future<void> startRecording() async {
    try {
      await _recorder.openRecorder();
      String pathToSave = await _path.path();
      log(pathToSave);
      await _recorder.startRecorder(
        toFile: pathToSave,
        codec: Codec.pcm16WAV, // Use WAV format
        sampleRate: 16000, // Set the sample rate to 16 kHz
        numChannels: 1, // Set the number of channels to mono
      );
      log('Recording started');
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Future<void> stopRecording() async {
    try {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
      log('Recording stopped');
    } catch (e) {
      log('Error: $e');
    }
  }
}