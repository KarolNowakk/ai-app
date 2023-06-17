import 'package:app2/shared/conversation/domain/preset.dart';
import 'package:app2/shared/conversation/domain/preset_repo.dart';
import 'package:app2/shared/conversation/domain/preset_chat.dart';
import 'package:app2/shared/helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';

class PresetsProvider<T extends Preset> with ChangeNotifier {
  final PresetsRepoInterface<T> _repo = KiwiContainer().resolve<PresetsRepoInterface<T>>();
  T? _currentItem;
  final List<T> _items = [];
  int _indexUpdating = -1;

  int get count => _items.length;
  T? currentItem() => _currentItem;

  T item(int i) => _items[i];

  void setIndexToUpdate(int index) {
    _indexUpdating = index;
  }

  void resetCurrent() {
    _currentItem = null;
    _indexUpdating = -1;
  }

  void resetAll() {
    _items.clear();
  }

  void loadItems() async {
    List<T> items = await _repo.getAll();
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  void chooseItem(int index) {
    _currentItem = item(index);
    notifyListeners();
  }

  void save(T item) {
    if (_indexUpdating != -1) {
      _items[_indexUpdating] = item;
      _repo.update(item);
      notifyListeners();
      return;
    }

    item.id = generateRandomString(19);

    _items.add(item);
    _repo.add(item);
    _currentItem = item;

    _indexUpdating = _findItemIndexById(item.id);
    notifyListeners();
  }

  void delete(int index) {
    T preset = item(index);
    _repo.delete(preset);
    _items.removeAt(index);
    notifyListeners();
  }

  int _findItemIndexById(String id) {
    return _items.indexWhere((element) => element.id == id);
  }
}