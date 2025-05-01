import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme bodyTextTheme = GoogleFonts.getTextTheme('Lato');
TextTheme displayTextTheme = GoogleFonts.getTextTheme('Pridi');

TextTheme textTheme = displayTextTheme.copyWith(
  headlineLarge: bodyTextTheme.headlineLarge,
  headlineMedium: bodyTextTheme.headlineMedium,
  headlineSmall: bodyTextTheme.headlineSmall,
  titleLarge: bodyTextTheme.titleLarge,
  titleMedium: bodyTextTheme.titleMedium,
  titleSmall: bodyTextTheme.titleSmall,
  bodyLarge: bodyTextTheme.bodyLarge,
  bodyMedium: bodyTextTheme.bodyMedium,
  bodySmall: bodyTextTheme.bodySmall,
  labelLarge: bodyTextTheme.labelLarge,
  labelMedium: bodyTextTheme.labelMedium,
  labelSmall: bodyTextTheme.labelSmall,
);