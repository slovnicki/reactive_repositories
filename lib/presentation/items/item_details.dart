import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repositories/application/items/details/cubit/details_cubit.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailsCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _child(context, state),
    );
  }

  Widget _child(BuildContext context, DetailsState state) {
    if (state is DetailsLoaded ||
        state is DetailsLoading && state.item != null) {
      final item =
          state is DetailsLoaded ? state.item : (state as DetailsLoading).item!;
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
          state is DetailsLoading
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
    if (state is DetailsError) {
      return Text(state.message);
    }
    return const SizedBox(
      width: 32,
      height: 64,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
