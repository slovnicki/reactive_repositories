import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repositories/application/items/details/cubit/details_cubit.dart';
import 'package:reactive_repositories/application/items/list/cubit/list_cubit.dart';
import 'package:reactive_repositories/application/routing/modal_bottom_sheet_route.dart';
import 'package:reactive_repositories/presentation/items/items.dart';

class ItemsBeamLocation extends BeamLocation<BeamState> {
  ItemsBeamLocation(super.routeInformation);

  @override
  List<Pattern> get pathPatterns => ['/:itemId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      BeamPage(
        key: const ValueKey('items'),
        child: BlocProvider(
          create: (_) => ListCubit()..load(),
          child: const ListScreen(),
        ),
      ),
    ];

    if (state.pathParameters.containsKey('itemId')) {
      final itemId = int.tryParse(state.pathParameters['itemId']!);
      pages.add(
        BeamPage(
          key: ValueKey('item-$itemId'),
          child: BlocProvider(
            create: (_) => DetailsCubit()..load(itemId),
            child: const DetailsModal(),
          ),
          routeBuilder: (context, settings, child) => _responsiveDetailsRoute(
            context: context,
            settings: settings,
            child: child,
          ),
        ),
      );
    }

    return pages;
  }

  Route _responsiveDetailsRoute({
    required BuildContext context,
    required RouteSettings settings,
    required Widget child,
  }) =>
      MediaQuery.of(context).size.width > 600
          ? DialogRoute(
              context: context,
              settings: settings,
              builder: (_) => Dialog(child: child),
            )
          : ModalBottomSheetRoute(
              settings: settings,
              isScrollControlled: false,
              builder: (_) => child,
            );
}
