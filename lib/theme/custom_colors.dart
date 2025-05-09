import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;
  final Color? location;
  final Color? onLocation;
  final Color? locationContainer;
  final Color? onLocationContainer;

  CustomColors({
    this.success = const Color(0xff326941),
    this.onSuccess = const Color(0xffffffff),
    this.successContainer = const Color(0xffb4f1bd),
    this.onSuccessContainer = const Color(0xff18512b),
    this.location = const Color(0xff2f58bc),
    this.onLocation = const Color(0xffffffff),
    this.locationContainer = const Color(0xff7297ff),
    this.onLocationContainer = const Color(0xff002d7c)
  });

  @override
  CustomColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? location,
    Color? onLocation,
    Color? locationContainer,
    Color? onLocationContainer
  }) {
    return CustomColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      location: location ?? this.location,
      onLocation: onLocation ?? this.onLocation,
      locationContainer: locationContainer ?? this.locationContainer,
      onLocationContainer: onLocationContainer ?? this.onLocationContainer
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
      location: Color.lerp(location, other.location, t),
      onLocation: Color.lerp(onLocation, other.onLocation, t),
      locationContainer: Color.lerp(locationContainer, other.locationContainer, t),
      onLocationContainer: Color.lerp(onLocationContainer, other.onLocationContainer, t)
    );
  }
}