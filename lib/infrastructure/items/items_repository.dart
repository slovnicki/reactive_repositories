import 'package:reactive_repositories/domain/items/item.dart';
import 'package:reactive_repositories/domain/items/items_repository.dart';

class FakeItemsRepository extends ItemsRepository {
  List<Item> _currentItems = [];

  @override
  Future<void> fetchAll({bool force = false}) async {
    if (_currentItems.isEmpty || force) {
      await Future.delayed(const Duration(milliseconds: 400));
      _currentItems = List.generate(12, (_) => Item.fake());
    }

    addToStream(_currentItems);
  }

  @override
  Future<Item?> getOne(int itemId) async {
    if (_currentItems.isEmpty) {
      await fetchAll();
    }

    try {
      return _currentItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Item?> toggleFavorite(int itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final item = await getOne(itemId);
    if (item == null) {
      return null;
    }

    final toggledItem = item.copyWith(isFavorite: !item.isFavorite);
    _updateCurrentItemsWith(toggledItem);

    addToStream(_currentItems);

    return toggledItem;
  }

  void _updateCurrentItemsWith(Item item) {
    final index = _currentItems.indexWhere((it) => it.id == item.id);
    if (index != -1) {
      _currentItems[index] = item;
    }
  }
}
