import 'package:go_router/go_router.dart';

import 'cola_route_data.dart';

class ColaRouterState<T extends ColaRouteData> {
  const ColaRouterState({
    required this.state,
    required this.data,
  });

  final GoRouterState state;
  final T data;
}
