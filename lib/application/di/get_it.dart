import 'package:get_it/get_it.dart';
import 'package:reactive_repositories/domain/items/items_repository.dart';
import 'package:reactive_repositories/infrastructure/items/items_repository.dart';

final getIt = GetIt.instance;

void registerRepositories() {
  getIt.registerLazySingleton<ItemsRepository>(
    () => FakeItemsRepository(),
  );
}
