import 'package:app2/shared/audio_app/change_lang_modal.dart';
import 'package:app2/shared/audio_app/recorder.dart';
import 'package:app2/shared/audio_app/speech_to_text.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class RecordButton extends StatefulWidget {
  final Function(String) getTranscribedText;
  final AudioRecorderInterface _audioR = KiwiContainer().resolve<AudioRecorderInterface>();
  final SpeechToTextInterface _speechToText = KiwiContainer().resolve<SpeechToTextInterface>();
  final ChangeSTTLanguageModalController _modal = ChangeSTTLanguageModalController();

  RecordButton({super.key, required this.getTranscribedText});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  Future<void> getTranscription() async {
    String transcribedText = await widget._speechToText.getTranscription();
    widget.getTranscribedText(transcribedText);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sizeAnimation =
        Tween<double>(begin: 30, end: 40).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> recordOrStopRecording() async {
    if (!_isRecording) {
      await widget._audioR.startRecording();
      setState(() {
        _isRecording = true;
      });
      _animationController.forward();
    } else {
      await widget._audioR.stopRecording();
      setState(() {
        _isRecording = false;
      });

      getTranscription();
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          color: DarkTheme.textColor,
        ),
      ),
      onPressed: () {
        recordOrStopRecording();
      },
      onLongPress: () {
        widget._modal.showQuickTranslateModal(context);
      },
      child: AnimatedBuilder(
        animation: _sizeAnimation,
        builder: (context, child) {
          return Icon(
            Icons.mic,
            color: _isRecording ? Colors.red : DarkTheme.secondary,
            size: _sizeAnimation.value,
          );
        },
      ),
    );
  }
}