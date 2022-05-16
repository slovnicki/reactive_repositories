import 'package:faker/faker.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.description,
    this.isFavorite = false,
  });

  factory Item.fake() => Item(
        id: faker.randomGenerator.integer(10000),
        name: faker.food.dish(),
        description: faker.lorem.sentence(),
        isFavorite: faker.randomGenerator.integer(5) == 0,
      );

  final int id;
  final String name;
  final String description;
  final bool isFavorite;

  Item copyWith({
    String? name,
    String? description,
    bool? isFavorite,
  }) =>
      Item(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
