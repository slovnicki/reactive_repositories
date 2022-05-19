import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reactive_repositories/application/di/get_it.dart';
import 'package:reactive_repositories/application/routing/delegate.dart';

void main() {
  registerRepositories();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: rootRouterDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}
