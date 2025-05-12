import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? open;
  final Color? onOpen;
  final Color? openContainer;
  final Color? onOpenContainer;
  final Color? closed;
  final Color? onClosed;
  final Color? closedContainer;
  final Color? onClosedContainer;
  final Color? location;
  final Color? onLocation;
  final Color? locationContainer;
  final Color? onLocationContainer;

  CustomColors({
    this.open = const Color(0xff326941),
    this.onOpen = const Color(0xffffffff),
    this.openContainer = const Color(0xffb4f1bd),
    this.onOpenContainer = const Color(0xff18512b),
    this.closed = const Color(0xff696969),
    this.onClosed = const Color(0xffffffff),
    this.closedContainer = const Color(0xffd3d3d3),
    this.onClosedContainer = const Color(0xff4c4354),
    this.location = const Color(0xff2f58bc),
    this.onLocation = const Color(0xffffffff),
    this.locationContainer = const Color(0xff7297ff),
    this.onLocationContainer = const Color(0xff002d7c)
  });

  @override
  CustomColors copyWith({
    Color? open,
    Color? onOpen,
    Color? openContainer,
    Color? onOpenContainer,
    Color? closed,
    Color? onClosed,
    Color? closedContainer,
    Color? onClosedContainer,
    Color? location,
    Color? onLocation,
    Color? locationContainer,
    Color? onLocationContainer
  }) {
    return CustomColors(
      open: open ?? this.open,
      onOpen: onOpen ?? this.onOpen,
      openContainer: openContainer ?? this.openContainer,
      onOpenContainer: onOpenContainer ?? this.onOpenContainer,
      closed: closed ?? this.closed,
      onClosed: onClosed ?? this.onClosed,
      closedContainer: closedContainer ?? this.closedContainer,
      onClosedContainer: onClosedContainer ?? this.onClosedContainer,
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
      open: Color.lerp(open, other.open, t),
      onOpen: Color.lerp(onOpen, other.onOpen, t),
      openContainer: Color.lerp(openContainer, other.openContainer, t),
      onOpenContainer: Color.lerp(onOpenContainer, other.onOpenContainer, t),
      closed: Color.lerp(closed, other.closed, t),
      onClosed: Color.lerp(onClosed, other.onClosed, t),
      closedContainer: Color.lerp(closedContainer, other.closedContainer, t),
      onClosedContainer: Color.lerp(onClosedContainer, other.onClosedContainer, t),
      location: Color.lerp(location, other.location, t),
      onLocation: Color.lerp(onLocation, other.onLocation, t),
      locationContainer: Color.lerp(locationContainer, other.locationContainer, t),
      onLocationContainer: Color.lerp(onLocationContainer, other.onLocationContainer, t)
    );
  }
}