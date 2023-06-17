import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart';
import 'package:app2/shared/audio_app/recorder.dart';
import 'package:app2/shared/audio_app/speech_to_text.dart';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/lang/infrastructure/word_repo.dart';
import 'package:app2/plugins/lang/screens/chat/rate_modal.dart';
import 'package:app2/plugins/lang/screens/chat/save_word_modal.dart';
import 'package:app2/shared/conversation/domain/preset_repo.dart';
import 'package:app2/shared/conversation/infrastructure/presets_repo.dart';
import 'package:kiwi/kiwi.dart';

void setupLingApp() {
  final container = KiwiContainer();

  container.registerSingleton<Config>((c) => Config());
  container.registerSingleton<SaveWordModalInterface>((c) => SaveWordModalController());
  container.registerSingleton<SRSAlgInterface>((c) => SRSAlg());
  container.registerSingleton<WordsRepoInterface>((c) => WordRepo());
  container.registerSingleton<RateWordModalInterface>((c) => RatingModalController());

  container.registerSingleton<PresetsRepoInterface<ExerciseStructure>>((c)
    => PresetsRepo<ExerciseStructure>(fromJson: ExerciseStructure.fromJson, collectionName: ExerciseStructure.collectionName()));

  container.registerSingleton<WordApiClient>((c) => WordApiClient());

  container.registerSingleton<AudioRecorderInterface>((c) => Recorder());
  container.registerSingleton<SpeechToTextInterface>((c) => SpeechToText());
}