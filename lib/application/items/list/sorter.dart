import 'package:reactive_repositories/domain/items/item.dart';

class Sorter {
  List<Item> sortByFavorite(List<Item> items) {
    return items..sort((a, b) => a.isFavorite || !b.isFavorite ? -1 : 1);
  }

  List<Item> sortByName(List<Item> items) {
    return items..sort((a, b) => a.name.compareTo(b.name));
  }
}
