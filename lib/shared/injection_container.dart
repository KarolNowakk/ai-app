import 'package:app2/plugins/lang/application/categories_repo.dart';
import 'package:app2/plugins/lang/infrastructure/categories_repo.dart';
import 'package:app2/shared/auth/application/service.dart';
import 'package:app2/shared/auth/domain/service.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/conversation/domain/preset_repo.dart';
import 'package:app2/shared/conversation/infrastructure/presets_repo.dart';
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

  container.registerSingleton<PresetsRepoInterface<PresetChat>>((c)
    => PresetsRepo<PresetChat>(fromJson: PresetChat.fromJson, collectionName: PresetChat.collectionName()));
  container.registerSingleton<CategoriesRepoInterface>((c) => CategoriesRepo());

  container.registerInstance(ConvHistoryApiClient());
  container.registerSingleton<ConvHistoryRepoInterface>((c) => ConvHistoryRepo());
}