import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_repositories/application/di/get_it.dart';

import 'package:reactive_repositories/main.dart';
import 'package:reactive_repositories/presentation/items/list_screen.dart';

void main() {
  registerRepositories();

  testWidgets('App shows ListScreen on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(ListScreen), findsOneWidget);
  });
}
