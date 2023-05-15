import 'dart:async';
import 'dart:developer';
import 'package:app2/shared/file_manager/infrastructure/manager.dart';
import 'package:record/record.dart';

abstract class AudioRecorderInterface {
  Future<void> startRecording();
  Future<void> stopRecording();
}

class Recorder implements AudioRecorderInterface {
  static const _fileName = 'record.wav';

  final Record _audioRecorder = Record();
  final FileManager _path = FileManager();

  @override
  Future<void> startRecording() async {
    try {
      bool hasPermission = await _audioRecorder.hasPermission();
      if (hasPermission) {
        String pathToSave = await _path.path(_fileName);
        log('pathToSave: $pathToSave');
        await _audioRecorder.start(
          path: pathToSave,
          encoder: AudioEncoder.aacLc,
        );
        log('Recording started');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Future<void> stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();
      if (path != null) {
        log('Recording stopped: $path');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
