import 'package:beamer/beamer.dart';
import 'package:reactive_repositories/application/routing/items_beam_location.dart';

dynamic createRouterDelegate() => BeamerDelegate(
      locationBuilder: (routeInformation, _) =>
          ItemsBeamLocation(routeInformation),
    );
