import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ColorScheme, TextTheme, ThemeData generated using Material Theme Builder
const ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff5e5791),
  surfaceTint: Color(0xff5e5791),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffe5deff),
  onPrimaryContainer: Color(0xff473f77),
  secondary: Color(0xff5f5c71),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffe5dff9),
  onSecondaryContainer: Color(0xff474459),
  tertiary: Color(0xff7c5265),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffffd8e7),
  onTertiaryContainer: Color(0xff613b4d),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff93000a),
  surface: Color(0xfffdf8ff),
  onSurface: Color(0xff1c1b20),
  onSurfaceVariant: Color(0xff48454f),
  outline: Color(0xff78767f),
  outlineVariant: Color(0xffc9c5d0),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff313036),
  inversePrimary: Color(0xffc8bfff),
  primaryFixed: Color(0xffe5deff),
  onPrimaryFixed: Color(0xff1b1249),
  primaryFixedDim: Color(0xffc8bfff),
  onPrimaryFixedVariant: Color(0xff473f77),
  secondaryFixed: Color(0xffe5dff9),
  onSecondaryFixed: Color(0xff1c192b),
  secondaryFixedDim: Color(0xffc9c3dc),
  onSecondaryFixedVariant: Color(0xff474459),
  tertiaryFixed: Color(0xffffd8e7),
  onTertiaryFixed: Color(0xff301121),
  tertiaryFixedDim: Color(0xffecb8ce),
  onTertiaryFixedVariant: Color(0xff613b4d),
  surfaceDim: Color(0xffddd8e0),
  surfaceBright: Color(0xfffdf8ff),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff7f2fa),
  surfaceContainer: Color(0xfff1ecf4),
  surfaceContainerHigh: Color(0xffebe6ee),
  surfaceContainerHighest: Color(0xffe5e1e9),
);

TextTheme bodyTextTheme = GoogleFonts.getTextTheme("Lato");
TextTheme displayTextTheme = GoogleFonts.getTextTheme("Pridi");

TextTheme textTheme = displayTextTheme.copyWith(
  bodyLarge: bodyTextTheme.bodyLarge,
  bodyMedium: bodyTextTheme.bodyMedium,
  bodySmall: bodyTextTheme.bodySmall,
  labelLarge: bodyTextTheme.labelLarge,
  labelMedium: bodyTextTheme.labelMedium,
  labelSmall: bodyTextTheme.labelSmall,
);

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  textTheme: textTheme.apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  ),
  scaffoldBackgroundColor: colorScheme.surface,
  canvasColor: colorScheme.surface,
);