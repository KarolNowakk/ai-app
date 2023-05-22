import 'package:app2/shared/auth/application/service.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/shared/history/infrastructure/api/api.dart';
import 'package:app2/shared/history/infrastructure/history_repo.dart';
import 'package:app2/shared/text_to_speech/application/tts.dart';
import 'package:app2/shared/text_to_speech/domain/tts.dart';
import 'package:app2/shared/text_to_speech/infrastructure/file_reader.dart';
import 'package:app2/shared/text_to_speech/infrastructure/web_reader.dart';
import 'package:kiwi/kiwi.dart';

void setupSharedStuff() {
  final container = KiwiContainer();

  container.registerSingleton<WebReaderInterface>((c) => WebReader());
  container.registerSingleton<FileReaderInterface>((c) => FileReaderImpl());
  container.registerSingleton<TextToSpeechInterface>((c) => TextToSpeech());
  container.registerSingleton<AuthServiceInterface>((c) => AuthService());

  container.registerInstance(ConvHistoryApiClient());
  container.registerSingleton<ConvHistoryRepoInterface>((c) => ConvHistoryRepo());
}