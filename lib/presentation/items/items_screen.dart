import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repositories/application/items/list/cubit/list_cubit.dart';
import 'package:reactive_repositories/presentation/items/widgets/item_list_tile.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ListCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          InkWell(
            onTap: () => context.read<ListCubit>().reload(),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: _body(state),
    );
  }

  Widget _body(ListState state) {
    if (state is ListLoaded) {
      return ListView(
        children: state.items
            .map(
              (item) => ItemListTile(item: item),
            )
            .toList(),
      );
    }
    if (state is ListError) {
      return Text(state.message);
    }
    return const Center(child: CircularProgressIndicator());
  }
}
