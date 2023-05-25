import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';

class HistoryProvider with ChangeNotifier {
  final ConvHistoryRepoInterface _repo = KiwiContainer().resolve<ConvHistoryRepoInterface>();
  final List<ConvHistory> _history = [];

  List<ConvHistory> get history => _history;

  void loadHistory(String parentId) async {
    _history.clear();

    List<ConvHistory> list = await _repo.getAllForParent(parentId);
    _history.addAll(list);

    notifyListeners();
  }

  void delete(int index) {
    ConvHistory his = _history[index];
    _repo.delete(his);
    _history.removeAt(index);
    notifyListeners();
  }
}
