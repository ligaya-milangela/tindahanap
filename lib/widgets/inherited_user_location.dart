import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation extends InheritedWidget {
  final Position location;

  const UserLocation({
    super.key,
    required this.location,
    required super.child,
  });

  static UserLocation? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserLocation>();
  }

  static UserLocation of(BuildContext context) {
    final UserLocation? result = maybeOf(context);
    assert(result != null, 'No UserLocation found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(UserLocation oldWidget) => location != oldWidget.location;
}