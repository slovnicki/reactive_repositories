# Reactive Repositories

An example of listening to a `Stream` from repository layer (instead of explicitly using get/fetch) as a solution for BLoC to BLoC communication, inspired by [updated documentation at bloc library](https://bloclibrary.dev/#/architecture?id=bloc-to-bloc-communication) and [this tweet](https://twitter.com/slovnicki/status/1524065225959481344?s=20&t=GwAhl9dC-RcFRMiA7JmOTg).

### Check out the **[Medium article](https://medium.com/@lovnicki.sandro/blocs-with-reactive-repository-5fd440d3b1dc)** that explains everything in more detail

---

![example](https://github.com/slovnicki/reactive_repositories/blob/master/diagram.png)

## Example

The main thing to notice is how `ListCubit` reloads (and sorts by favorites) the `ItemsScreen` in reaction to `DetailsCubit` successfully toggling `isFavorite`, but `DetailsCubit` has no reference to `ListCubit`.

![example](https://github.com/slovnicki/reactive_repositories/blob/master/example.gif)

## BLoC

```dart
class ListCubit extends Cubit<ListState> {
  ListCubit()
      : _itemsRepository = getIt.get(),
        _sorter = Sorter(),
        super(ListLoading()) {
    _subscribe();
  }

  final ItemsRepository _itemsRepository;
  final Sorter _sorter;
  late final StreamSubscription _subscription;

  void load({bool force = false}) async {
    emit(ListLoading());
    await _itemsRepository.fetchAll(force: force);
  }

  void reload() => load(force: true);

  void _subscribe() {
    _subscription = _itemsRepository.items.listen(
      (items) {
        final sortedItems = _sorter.sortByFavorite(items);
        emit(ListLoaded(sortedItems));
      },
      onError: (error) => emit(ListError('$error')),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit()
      : _itemsRepository = getIt.get(),
        super(const DetailsLoading());

  final ItemsRepository _itemsRepository;
  Item? _currentItem;

  void load(int? itemId) async {
    emit(DetailsLoading(_currentItem));

    if (itemId == null) {
      emit(const DetailsError('Cannot parse itemId'));
      return;
    }

    try {
      _currentItem = await _itemsRepository.getOne(itemId);
      if (_currentItem != null) {
        emit(DetailsLoaded(_currentItem!));
      } else {
        emit(DetailsError('Cannot find item $itemId'));
      }
    } catch (e, st) {
      emit(DetailsError('$e: $st'));
    }
  }

  void toggleFavorite(int itemId) async {
    emit(DetailsLoading(_currentItem));

    _currentItem = await _itemsRepository.toggleFavorite(itemId);

    if (_currentItem != null) {
      emit(DetailsLoaded(_currentItem!));
    } else {
      emit(const DetailsError('Failed to toggle favorite'));
    }
  }
}
```

## Repository

```dart
abstract class ItemsRepository {
  final _controller = StreamController<List<Item>>();

  Stream<List<Item>> get items => _controller.stream;

  void addToStream(List<Item> items) => _controller.sink.add(items);

  Future<void> fetchAll({bool force = false});
  Future<Item?> getOne(int itemId);
  Future<Item?> toggleFavorite(int itemId);
}

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
```
