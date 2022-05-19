import 'package:beamer/beamer.dart';
import 'package:reactive_repositories/application/routing/items_beam_location.dart';

final rootRouterDelegate = BeamerDelegate(
  locationBuilder: (routeInformation, _) => ItemsBeamLocation(routeInformation),
);
