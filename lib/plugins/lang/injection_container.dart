import 'package:app2/plugins/lang/application/config.dart';
import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:app2/plugins/lang/infrastructure/AICommunicator.dart';
import 'package:app2/plugins/lang/infrastructure/api/exercises_api.dart';
import 'package:app2/plugins/lang/infrastructure/api/words_api.dart';
import 'package:app2/plugins/lang/infrastructure/current_exercise_repo.dart';
import 'package:app2/plugins/lang/infrastructure/exercises_repo.dart';
import 'package:app2/plugins/lang/infrastructure/word_repo.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/plugins/lang/screens/chat/chat_messages.dart';
import 'package:app2/plugins/lang/screens/chat/rate_modal.dart';
import 'package:app2/plugins/lang/screens/chat/save_word_modal.dart';
import 'package:app2/plugins/lang/screens/exercise/create.dart';
import 'package:app2/plugins/lang/screens/exercise/select.dart';
import 'package:kiwi/kiwi.dart';

void setupLingApp() {
  final container = KiwiContainer();

  container.registerSingleton<Config>((c) => Config());

  container.registerSingleton<SaveWordModalInterface>((c) => SaveWordModalController());

  container.registerSingleton<SRSAlgInterface>((c) => SRSAlg());
  container.registerSingleton<SRSUpdateInterface>((c) => SRSAlg());
  container.registerSingleton<CreateInitialSRSWordDataInterface>((c) => SRSAlg());

  container.registerSingleton<AICommunicatorInterface>((c) => AICommunicator());

  container.registerSingleton<WordsRepoPromptInterface>((c) => WordRepo());
  container.registerSingleton<WordRepoUpdateInterface>((c) => WordRepo());
  container.registerSingleton<CreateWordRepoInterface>((c) => WordRepo());

  container.registerSingleton<CurrentExerciseSettingsInterface>((c) => CurrentExerciseRepo());
  container.registerSingleton<CurrentExerciseSaverInterface>((c) => CurrentExerciseRepo());

  container.registerSingleton<PrompterInterface>((c) => Prompter());

  container.registerSingleton<WordExercisesController>((c) => WordExercisesController());

  container.registerSingleton<RateWordModalInterface>((c) => RatingModalController());

  container.registerSingleton<ExercisesRepoInterface>((c) => ExerciseRepo());
  container.registerSingleton<ExerciseSaverRepoInterface>((c) => ExerciseRepo());

  container.registerSingleton<ExerciseApiClient>((c) => ExerciseApiClient());
  container.registerSingleton<WordApiClient>((c) => WordApiClient());
}