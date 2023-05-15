import 'package:app2/plugins/lang/application/current_ecercise_repo.dart';
import 'package:app2/plugins/lang/application/exercise_repo.dart';
import 'package:app2/plugins/lang/application/words_repo.dart';
import 'package:app2/shared/audio_app/recorder.dart';
import 'package:app2/shared/audio_app/speech_to_text.dart';
import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/infrastructure/api/exercises_api.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/lang/infrastructure/current_exercise_repo.dart';
import 'package:app2/plugins/lang/infrastructure/exercises_repo.dart';
import 'package:app2/plugins/lang/infrastructure/word_repo.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/lang/screens/chat/rate_modal.dart';
import 'package:app2/plugins/lang/screens/chat/save_word_modal.dart';
import 'package:kiwi/kiwi.dart';

void setupLingApp() {
  final container = KiwiContainer();

  container.registerSingleton<Config>((c) => Config());
  container.registerSingleton<SaveWordModalInterface>((c) => SaveWordModalController());
  container.registerSingleton<SRSAlgInterface>((c) => SRSAlg());
  container.registerSingleton<WordsRepoInterface>((c) => WordRepo());
  container.registerSingleton<CurrentExerciseRepoInterface>((c) => CurrentExerciseRepo());
  container.registerSingleton<WordExercisesController>((c) => WordExercisesController());
  container.registerSingleton<RateWordModalInterface>((c) => RatingModalController());

  container.registerSingleton<ExerciseRepoInterface>((c) => ExerciseRepo());

  container.registerSingleton<ExerciseApiClient>((c) => ExerciseApiClient());
  container.registerSingleton<WordApiClient>((c) => WordApiClient());

  container.registerSingleton<AudioRecorderInterface>((c) => Recorder());
  container.registerSingleton<SpeechToTextInterface>((c) => SpeechToText());
}