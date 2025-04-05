import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ColorScheme, TextTheme, ThemeData generated using Material Theme Builder
const ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff6e00c1),
  surfaceTint: Color(0xff8422dc),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xff8a2be2),
  onPrimaryContainer: Color(0xffeed9ff),
  secondary: Color(0xff744b9f),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffd0a3fe),
  onSecondaryContainer: Color(0xff5b3385),
  tertiary: Color(0xff92006d),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffb8178b),
  onTertiaryContainer: Color(0xffffd6e9),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff93000a),
  surface: Color(0xfffff7ff),
  onSurface: Color(0xff1f1924),
  onSurfaceVariant: Color(0xff4c4354),
  outline: Color(0xff7e7386),
  outlineVariant: Color(0xffcfc2d7),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff342e39),
  inversePrimary: Color(0xffdcb8ff),
  primaryFixed: Color(0xffefdbff),
  onPrimaryFixed: Color(0xff2c0051),
  primaryFixedDim: Color(0xffdcb8ff),
  onPrimaryFixedVariant: Color(0xff6700b5),
  secondaryFixed: Color(0xffefdbff),
  onSecondaryFixed: Color(0xff2c0051),
  secondaryFixedDim: Color(0xffdcb8ff),
  onSecondaryFixedVariant: Color(0xff5b3385),
  tertiaryFixed: Color(0xffffd8ea),
  onTertiaryFixed: Color(0xff3c002b),
  tertiaryFixedDim: Color(0xffffaeda),
  onTertiaryFixedVariant: Color(0xff890066),
  surfaceDim: Color(0xffe1d6e5),
  surfaceBright: Color(0xfffff7ff),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfffbf0ff),
  surfaceContainer: Color(0xfff5eaf9),
  surfaceContainerHigh: Color(0xfff0e5f3),
  surfaceContainerHighest: Color(0xffeadfee),
);

TextTheme bodyTextTheme = GoogleFonts.getTextTheme('Lato');
TextTheme displayTextTheme = GoogleFonts.getTextTheme('Pridi');

TextTheme textTheme = displayTextTheme.copyWith(
  bodyLarge: bodyTextTheme.bodyLarge,
  bodyMedium: bodyTextTheme.bodyMedium,
  bodySmall: bodyTextTheme.bodySmall,
  labelLarge: bodyTextTheme.labelLarge,
  labelMedium: bodyTextTheme.labelMedium,
  labelSmall: bodyTextTheme.labelSmall,
);