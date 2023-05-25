import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/conversation/domain/preset_repo.dart';
import 'package:app2/shared/conversation/infrastructure/api/presets.dart';

class PresetsRepo<T extends Preset> implements PresetsRepoInterface<T> {
  final PresetsApiClient _api;

  final T Function(Map<String, dynamic>) fromJson;

  PresetsRepo({required this.fromJson, required String collectionName}) :
        _api = PresetsApiClient(collectionName);

  @override
  Future<List<T>> getAll() async {
    List<Map<String, dynamic>> rawList = await _api.getAll();

    List<T> exerciseList = rawList.map((exercise) => fromJson(exercise)).toList();

    return exerciseList;
  }

  @override
  void delete(T preset) {
    _api.delete(preset.id!);
  }

  @override
  void add(T data) {
    Map<String, dynamic> exerciseData = data.toJson();
    _api.create(exerciseData);
  }

  @override
  void update(T data) {
    Map<String, dynamic> exerciseData = data.toJson();
    _api.update(exerciseData);
  }
}