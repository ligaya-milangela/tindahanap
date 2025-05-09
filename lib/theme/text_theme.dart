import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme displayTextTheme = GoogleFonts.getTextTheme('Pridi');
TextTheme headlineTextTheme = GoogleFonts.getTextTheme('Poppins');
TextTheme bodyTextTheme = GoogleFonts.getTextTheme('Lato');


TextTheme textTheme = displayTextTheme.copyWith(
  headlineLarge: headlineTextTheme.headlineLarge,
  headlineMedium: headlineTextTheme.headlineMedium,
  headlineSmall: headlineTextTheme.headlineSmall,
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