part of 'list_cubit.dart';

abstract class ListState {
  const ListState();
}

class ListLoading extends ListState {}

class ListError extends ListState {
  const ListError(this.message);

  final String message;
}

class ListLoaded extends ListState {
  const ListLoaded(this.items);

  final List<Item> items;
}
