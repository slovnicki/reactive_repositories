import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reactive_repositories/domain/items/item.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.beamToNamed('${item.id}'),
      child: ListTile(
        trailing: item.isFavorite ? const Icon(Icons.check) : null,
        title: Text(item.name),
        subtitle: Text(item.description),
      ),
    );
  }
}
