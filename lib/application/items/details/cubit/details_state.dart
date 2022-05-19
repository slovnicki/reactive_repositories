part of 'details_cubit.dart';

abstract class DetailsState {
  const DetailsState();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading([this.item]);

  final Item? item;
}

class DetailsError extends DetailsState {
  const DetailsError(this.message);

  final String message;
}

class DetailsLoaded extends DetailsState {
  const DetailsLoaded(this.item);

  final Item item;
}
