import 'package:app2/plugins/playground/domain/ai_service.dart';
import 'package:app2/plugins/playground/infrastructure/ai_service.dart';
import 'package:kiwi/kiwi.dart';

void setupPlayground() {
  final container = KiwiContainer();

  container.registerSingleton<AIServiceInterface>((c) => AIService());
}