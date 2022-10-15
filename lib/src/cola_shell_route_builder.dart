import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef ColaShellRouteWidgetBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  Widget child,
);

typedef ColaShellRoutePageBuilder = Page Function(
  BuildContext context,
  GoRouterState state,
  Widget child,
);

class ColaShellRouteBuilder {
  ColaShellRouteBuilder({
    this.builder,
    this.pageBuilder,
  });

  final ColaShellRouteWidgetBuilder? builder;
  final ColaShellRoutePageBuilder? pageBuilder;

  ShellRoute $route({
    List<GoRoute> routes = const [],
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return ShellRoute(
      routes: routes,
      navigatorKey: navigatorKey,
      builder: builder,
      pageBuilder: pageBuilder,
    );
  }
}
