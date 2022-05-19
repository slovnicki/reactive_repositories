import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repositories/application/items/details/cubit/details_cubit.dart';
import 'package:reactive_repositories/domain/items/item.dart';

class DetailsModal extends StatelessWidget {
  const DetailsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailsCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _child(state),
    );
  }

  Widget _child(DetailsState state) {
    if (state is DetailsLoaded ||
        state is DetailsLoading && state.item != null) {
      return _Details(
        item: state is DetailsLoaded
            ? state.item
            : (state as DetailsLoading).item!,
        isLoading: state is DetailsLoading,
      );
    }
    if (state is DetailsError) {
      return Text(state.message);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key? key,
    required this.item,
    this.isLoading = false,
  }) : super(key: key);

  final Item item;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            if (item.isFavorite) ...[
              const SizedBox(width: 16.0),
              const Icon(Icons.check)
            ],
          ],
        ),
        Text(item.description),
        const SizedBox(height: 16.0),
        isLoading
            ? const SizedBox(
                height: 28.0,
                width: 32.0,
                child: Center(child: CircularProgressIndicator()),
              )
            : ElevatedButton(
                onPressed: () =>
                    context.read<DetailsCubit>().toggleFavorite(item.id),
                child: const Text('Toggle favorite'),
              ),
      ],
    );
  }
}
