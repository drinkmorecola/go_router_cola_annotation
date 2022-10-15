import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'cola_route_data.dart';
import 'cola_router_state.dart';

class ColaRouteConfig<T extends ColaRouteData> {
  const ColaRouteConfig({
    required this.data,
    required this.builder,
  });

  final T data;
  final ColaRouteBuildable<T> builder;

  String get location => builder.$toLocation(data);
}

typedef ColaRouteWidgetBuilder<T extends ColaRouteData> = Widget Function(
  BuildContext context,
  ColaRouterState<T> state,
);

typedef ColaRoutePageBuilder<T extends ColaRouteData> = Page Function(
  BuildContext context,
  ColaRouterState<T> state,
);

typedef ColaRouteRedirect<T extends ColaRouteData> = FutureOr<String?> Function(
  BuildContext context,
  ColaRouterState<T> state,
);

typedef ColaToLocation<T> = String Function(T data);

typedef ColaFromState<T> = T Function(GoRouterState state);

abstract class ColaRouteBuildable<T extends ColaRouteData> {
  const ColaRouteBuildable({
    this.builder,
    this.pageBuilder,
    this.redirect,
  });

  final ColaRouteWidgetBuilder<T>? builder;
  final ColaRoutePageBuilder<T>? pageBuilder;
  final ColaRouteRedirect<T>? redirect;

  ColaToLocation<T> get $toLocation;
  ColaFromState<T> get $fromState;

  GoRoute $route({
    required String path,
    List<GoRoute> routes = const [],
    GlobalKey<NavigatorState>? parentNavigatorKey,
  }) {
    ColaRouterState<T> fromState(GoRouterState state) {
      final extra = state.extra;

      // If the "extra" value is of type `T` then we know it's the source
      // instance of `GoRouteData`, so it doesn't need to be recreated.
      if (extra is T) {
        return ColaRouterState(
          state: state,
          data: extra,
        );
      }

      return ColaRouterState(
        state: state,
        data: (_stateObjectExpando[state] ??= $fromState(state)) as T,
      );
    }

    return GoRoute(
      path: path,
      routes: routes,
      parentNavigatorKey: parentNavigatorKey,
      builder: builder == null
          ? null
          : (context, state) => builder!(context, fromState(state)),
      pageBuilder: pageBuilder == null
          ? null
          : (context, state) => pageBuilder!(context, fromState(state)),
      redirect: redirect == null
          ? null
          : (context, state) => redirect!(context, fromState(state)),
    );
  }

  ColaRouteConfig<T> buildConfig(T data) => ColaRouteConfig(
        data: data,
        builder: this,
      );

  /// Used to cache [GoRouteData] that corresponds to a given [GoRouterState]
  /// to minimize the number of times it has to be deserialized.
  static final _stateObjectExpando = Expando<ColaRouteData>(
    'GoRouteState to GoRouteData expando',
  );
}

class ColaRouteBuilder<T extends ColaRouteData> extends ColaRouteBuildable<T> {
  const ColaRouteBuilder({
    required this.$toLocation,
    required this.$fromState,
    super.builder,
    super.pageBuilder,
    super.redirect,
  });

  @override
  final ColaToLocation<T> $toLocation;

  @override
  final ColaFromState<T> $fromState;
}
