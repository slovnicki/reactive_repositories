import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_repositories/application/di/get_it.dart';
import 'package:reactive_repositories/domain/items/item.dart';
import 'package:reactive_repositories/domain/items/items_repository.dart';

part 'details_state.dart';

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
      emit(const DetailsError('Failed to toggleFavorite'));
    }
  }
}
