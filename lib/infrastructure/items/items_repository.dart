import 'package:reactive_repositories/domain/items/item.dart';
import 'package:reactive_repositories/domain/items/items_repository.dart';

class FakeItemsRepository extends ItemsRepository {
  List<Item> _items = [];

  @override
  Future<void> fetchAll({bool force = false}) async {
    if (_items.isEmpty || force) {
      await Future.delayed(const Duration(milliseconds: 400));
      _items = List.generate(12, (_) => Item.fake());
    }

    add(_items);
  }

  @override
  Future<Item?> getOne(int itemId) async {
    if (_items.isEmpty) {
      await fetchAll();
    }

    try {
      return _items.firstWhere((item) => item.id == itemId);
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

    final newItem = item.copyWith(isFavorite: !item.isFavorite);
    _update(newItem);
    add(_items);

    return newItem;
  }

  void _update(Item item) {
    final index = _items.indexWhere((it) => it.id == item.id);

    if (index != -1) {
      _items[index] = item;
    }
  }
}
