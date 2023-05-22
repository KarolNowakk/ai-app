import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/shared/history/infrastructure/api/api.dart';
import 'package:kiwi/kiwi.dart';

class ConvHistoryRepo implements ConvHistoryRepoInterface {
  final ConvHistoryApiClient _api = KiwiContainer().resolve<ConvHistoryApiClient>();

  @override
  Future<List<ConvHistory>> getAllForParent(String parentId) async {
    List<Map<String, dynamic>> rawList = await _api.getAll(parentId);
    List<ConvHistory> historyList = rawList.map((exercise) => ConvHistory.fromJson(exercise)).toList();

    return historyList.reversed.toList();
  }

  @override
  Future<void> updateHistory(ConvHistory history) async {
    Map<String, dynamic> wordData = history.toJson();
    _api.update(wordData);
  }

  @override
  Future<void> createHistory(ConvHistory history) async {
    Map<String, dynamic> wordData = history.toJson();

    wordData["created_at"] = DateTime.now().toIso8601String();
    _api.create(wordData);
  }

  @override
  Future<void> deleteHistory(ConvHistory history) async {
    _api.delete(history.id);
  }
}