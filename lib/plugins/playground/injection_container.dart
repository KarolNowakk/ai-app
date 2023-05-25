import 'package:app2/shared/conversation/domain/ai_service.dart';
import 'package:app2/plugins/playground/infrastructure/ai_service.dart';
import 'package:kiwi/kiwi.dart';

void setupPlayground() {
  final container = KiwiContainer();

  container.registerSingleton<AIServiceInterface>((c) => AIService());
}