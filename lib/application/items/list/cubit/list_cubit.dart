import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repositories/application/di/get_it.dart';
import 'package:reactive_repositories/application/items/list/sorter.dart';
import 'package:reactive_repositories/domain/items/item.dart';
import 'package:reactive_repositories/domain/items/items_repository.dart';

part 'list_state.dart';

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
