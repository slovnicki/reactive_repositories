import 'dart:async';

import 'package:reactive_repositories/domain/items/item.dart';

abstract class ItemsRepository {
  final _controller = StreamController<List<Item>>();
  void add(List<Item> items) => _controller.sink.add(items);
  Stream<List<Item>> get items => _controller.stream;

  Future<void> fetchAll({bool force = false});
  Future<Item?> getOne(int itemId);
  Future<Item?> toggleFavorite(int itemId);
}
