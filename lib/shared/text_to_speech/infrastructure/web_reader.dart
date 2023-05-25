import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/shared/text_to_speech/application/tts.dart';
import 'package:http/http.dart' as http;
import 'package:kiwi/kiwi.dart';

class WebReader extends WebReaderInterface {
  final Config _config = KiwiContainer().resolve<Config>();
  final _voiceID = "21m00Tcm4TlvDq8ikWAM";

  @override
  Future<Uint8List?> readAudioFromWeb(String text) async {
    final String url = 'https://api.elevenlabs.io/v1/text-to-speech/$_voiceID';

    final Map<String, String> headers = {
      'accept': 'audio/mpeg',
      'xi-api-key': _config.getEntry(elevenLabsApiKey),
      'Content-Type': 'application/json',
    };

    final String requestBody = jsonEncode({
      'model_id': 'eleven_multilingual_v1',
      'text': text,
      'voice_settings': {'stability': 0.1, 'similarity_boost': 0.1},
    });

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      log('Request failed with status code: ${response.statusCode}, ${response.body}');
      return null;
    }
  }
}