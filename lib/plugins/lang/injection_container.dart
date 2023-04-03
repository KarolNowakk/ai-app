import 'package:app2/plugins/lang/application/prompter.dart';
import 'package:app2/plugins/lang/domain/AICommunicator.dart';
import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/domain/prompter.dart';
import 'package:app2/plugins/lang/infrastructure/AICommunicator.dart';
import 'package:app2/plugins/lang/infrastructure/prompt_repo.dart';
import 'package:app2/plugins/lang/infrastructure/word_repo.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/plugins/lang/screens/chat_messages.dart';
import 'package:app2/plugins/lang/screens/rate_modal.dart';
import 'package:app2/plugins/lang/screens/save_word_modal.dart';
import 'package:kiwi/kiwi.dart';

void setupLingApp() {
  final container = KiwiContainer();
  container.registerSingleton<SaveWordModalInterface>((c) => SaveWordModalController());

  container.registerSingleton<SRSAlgInterface>((c) => SRSAlg());
  container.registerSingleton<SRSUpdateInterface>((c) => SRSAlg());
  container.registerSingleton<CreateInitialSRSWordDataInterface>((c) => SRSAlg());

  container.registerSingleton<AICommunicatorInterface>((c) => AICommunicator());

  container.registerSingleton<WordsRepoPromptInterface>((c) => WordRepo());
  container.registerSingleton<WordRepoUpdateInterface>((c) => WordRepo());
  container.registerSingleton<CreateWordRepoInterface>((c) => WordRepo());

  container.registerSingleton<ExercisesPromptSettingsInterface>((c) => PromptSettingsRepo());
  container.registerSingleton<PrompterInterface>((c) => Prompter());

  container.registerSingleton<WordExercisesController>((c) => WordExercisesController());
  
  container.registerSingleton<RateWordModalInterface>((c) => RatingModalController());
}