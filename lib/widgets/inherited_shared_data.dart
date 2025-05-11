import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/search_service.dart';

class SharedData extends InheritedWidget {
  final List<String> categories = ['Food', 'Drinks', 'Hygiene', 'Medicine', 'Household', 'Convenience'];
  final Filters filters;
  final Position location;

  SharedData({
    super.key,
    required this.filters,
    required this.location,
    required super.child,
  });

  static SharedData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SharedData>();
  }

  static SharedData of(BuildContext context) {
    final SharedData? result = maybeOf(context);
    assert(result != null, 'No SharedData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SharedData oldWidget) {
    return filters != oldWidget.filters ||
           location != oldWidget.location;
  }
}