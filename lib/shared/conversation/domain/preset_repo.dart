import 'package:app2/shared/conversation/domain/preset.dart';

abstract class PresetsRepoInterface<T extends Preset> {
  Future<List<T>> getAll();
  void add(T preset);
  void update(T preset);
  void delete(T preset);
}