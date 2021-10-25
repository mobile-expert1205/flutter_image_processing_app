import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// The requested action type of given route
enum RouteActionType {
  push,
  pushReplacement,
}

/// The model of Route to Navigate
class AppRoute {
  /// Action type of route
  final RouteActionType routeActionType;

  /// Name of the route
  final String routeName;

  /// Constructor
  AppRoute({
    required this.routeActionType,
    required this.routeName,
  });

  /// Equal operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppRoute &&
          runtimeType == other.runtimeType &&
          routeActionType == other.routeActionType &&
          routeName == other.routeName;

  /// Returns hash code of this
  @override
  int get hashCode => routeActionType.hashCode ^ routeName.hashCode;

  /// Returns string representation of this
  @override
  String toString() {
    return 'StreamRoute{routeActionType: $routeActionType, routeName: $routeName}';
  }
}

/// This class implements business-logic of navigation.
class AppRouterBloc implements AppRouter {
  /// Private stream controller provides current route.
  final PublishSubject<AppRoute> _route = PublishSubject();

  /// Public stream provides current route.
  /// Distinct operator is used to skips data events
  /// if they are equal to the previous data event.
  Stream<AppRoute> get route => _route.stream.distinct();

  /// Pushes given [routeName]
  @override
  void pushNamed(String routeName) {
    final AppRoute route = AppRoute(
      routeActionType: RouteActionType.push,
      routeName: routeName,
    );
    _route.add(route);
  }

  /// Pushes with Replacement given [routeName]
  @override
  void pushReplacement(String routeName) {
    final AppRoute route = AppRoute(
      routeActionType: RouteActionType.pushReplacement,
      routeName: routeName,
    );
    _route.add(route);
  }

  void pushReplacementDelayed(String routeName, Duration duration) async {
    await Future.delayed(duration);
    final AppRoute route = AppRoute(
      routeActionType: RouteActionType.pushReplacement,
      routeName: routeName,
    );
    _route.add(route);
  }

  /// Closes all prior initialised streams
  void dispose() {
    _route.close();
  }
}

abstract class AppRouter {
  void pushNamed(String routeName);

  void pushReplacement(String routeName);
}
