import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reactive_repositories/application/di/get_it.dart';
import 'package:reactive_repositories/application/routing/delegate.dart';

void main() {
  registerRepositories();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = createRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}
