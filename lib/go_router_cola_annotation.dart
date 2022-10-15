library go_router_cola_annotation;

export 'src/cola_route_builder.dart';
export 'src/cola_route_data.dart';
export 'src/cola_router_state.dart';
export 'src/cola_shell_route_builder.dart';

extension ObjectCastExtension on Object {
  T? cast<T>() => (this is T) ? this as T : null;
}
