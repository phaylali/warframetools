import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color goldColor = Color(0xFFC2B067);
  static const Color pureBlack = Color(0xFF000000);
  static const double borderWidth = 1.5;

  static LinearGradient get goldFadeGradient {
    return LinearGradient(
      colors: [
        goldColor.withAlpha(0),
        goldColor.withAlpha(0),
        goldColor,
        goldColor,
        goldColor.withAlpha(0),
        goldColor.withAlpha(0),
      ],
      stops: const [0.0, 0.05, 0.2, 0.8, 0.95, 1.0],
    );
  }

  static ThemeData get spaceTheme => _buildTheme(pureBlack);
  static ThemeData get moonTheme => _buildTheme(const Color(0xFF1E1E1E));

  static ThemeData _buildTheme(Color backgroundColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      cardColor: backgroundColor,
      dividerColor: goldColor.withAlpha(100),
      colorScheme: ColorScheme.dark(
        primary: goldColor,
        onPrimary: backgroundColor,
        secondary: goldColor,
        onSecondary: backgroundColor,
        surface: backgroundColor,
        onSurface: goldColor,
        outline: goldColor,
        primaryContainer: backgroundColor == pureBlack
            ? const Color(0xFF1A1A1A)
            : backgroundColor.withAlpha(40),
        onPrimaryContainer: goldColor,
      ),
      textTheme: GoogleFonts.cinzelTextTheme().copyWith(
        displayLarge: GoogleFonts.cinzel(
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [goldColor, Color(0xFFFFE082), goldColor],
              stops: [0.0, 0.5, 1.0],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
        headlineLarge: GoogleFonts.cinzel(
          fontWeight: FontWeight.w700,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [goldColor, Color(0xFFFFE082), goldColor],
              stops: [0.0, 0.5, 1.0],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
        titleLarge: GoogleFonts.cinzel(
          fontWeight: FontWeight.w600,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [goldColor, Color(0xFFFFE082), goldColor],
              stops: [0.0, 0.5, 1.0],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
        titleMedium: GoogleFonts.sourceSans3(
            color: goldColor, fontWeight: FontWeight.w700),
        titleSmall: GoogleFonts.sourceSans3(
            color: goldColor, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.sourceSans3(color: goldColor),
        bodyMedium: GoogleFonts.sourceSans3(color: goldColor),
        bodySmall: GoogleFonts.sourceSans3(color: goldColor.withAlpha(180)),
        labelLarge: GoogleFonts.sourceSans3(
            color: goldColor, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: goldColor, width: borderWidth),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: goldColor,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [goldColor, Color(0xFFFFE082), goldColor],
              stops: [0.0, 0.5, 1.0],
            ).createShader(const Rect.fromLTWH(0, 0, 250, 50)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: goldColor, width: borderWidth),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: goldColor,
        textTheme: ButtonTextTheme.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: goldColor,
          side: const BorderSide(color: goldColor, width: borderWidth),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldColor,
          side: const BorderSide(color: goldColor, width: borderWidth),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: goldColor,
          textStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: backgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: goldColor, width: borderWidth),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: goldColor, width: borderWidth * 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        labelStyle: GoogleFonts.sourceSans3(color: goldColor),
        hintStyle: GoogleFonts.sourceSans3(color: goldColor.withAlpha(120)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundColor,
        contentTextStyle: GoogleFonts.sourceSans3(color: goldColor),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: goldColor, width: borderWidth),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: goldColor, width: borderWidth),
          borderRadius: BorderRadius.circular(8),
        ),
        titleTextStyle: GoogleFonts.cinzel(
            color: goldColor, fontSize: 22, fontWeight: FontWeight.bold),
        contentTextStyle: GoogleFonts.sourceSans3(color: goldColor),
      ),
      dividerTheme: const DividerThemeData(
        color: goldColor,
        thickness: 1,
        space: 24,
        indent: 16,
        endIndent: 16,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: goldColor,
        textColor: goldColor,
        titleTextStyle:
            GoogleFonts.cinzel(fontWeight: FontWeight.w600, fontSize: 16),
        subtitleTextStyle: GoogleFonts.sourceSans3(fontSize: 14),
      ),
    );
  }

  static ThemeData get lightTheme => moonTheme;
  static ThemeData get darkTheme => spaceTheme;
}
