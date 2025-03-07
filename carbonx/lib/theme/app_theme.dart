import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme Colors
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color accentTeal = Color(0xFF76EAD7);
  static const Color accentLime = Color(0xFFC4FB6D);

  // Light Theme Colors
  static const Color primaryLight = Color(0xFFF8FAFC);
  static const Color secondaryLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);

  // Spacing
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 16.0;
  static const double spacing4 = 24.0;
  static const double spacing5 = 32.0;
  static const double spacing6 = 48.0;
  static const double spacing7 = 64.0;

  // Border Radius
  static const double borderRadius1 = 4.0;
  static const double borderRadius2 = 8.0;
  static const double borderRadius3 = 12.0;
  static const double borderRadius4 = 16.0;
  static const double borderRadius5 = 24.0;
  static const double borderRadiusRound = 100.0;

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDark,
    primaryColor: accentTeal,
    colorScheme: const ColorScheme.dark(
      primary: accentTeal,
      secondary: accentLime,
      surface: secondaryDark,
      background: primaryDark,
      error: Colors.redAccent,
      onPrimary: primaryDark,
      onSecondary: primaryDark,
      onSurface: textPrimary,
      onBackground: textPrimary,
      onError: textPrimary,
    ),
    textTheme: GoogleFonts.quicksandTextTheme().copyWith(
      displayLarge: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.quicksand(
        color: textSecondary,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.quicksand(
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      elevation: 0,
      titleTextStyle: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    cardTheme: const CardTheme(
      color: secondaryDark,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        vertical: spacing2,
        horizontal: spacing2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentTeal,
        foregroundColor: primaryDark,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: spacing3,
          horizontal: spacing4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentTeal,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: spacing2,
          horizontal: spacing3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: textSecondary),
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: spacing3,
          horizontal: spacing4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryDark,
      filled: true,
      contentPadding: const EdgeInsets.all(spacing3),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.quicksand(color: textSecondary),
      labelStyle: GoogleFonts.quicksand(color: textSecondary),
    ),
    dividerTheme: const DividerThemeData(
      color: textSecondary,
      thickness: 0.5,
      space: spacing3,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: secondaryDark,
      contentTextStyle: GoogleFonts.quicksand(color: textPrimary),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: secondaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
      titleTextStyle: GoogleFonts.quicksand(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      contentTextStyle: GoogleFonts.quicksand(
        color: textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: secondaryDark,
      selectedItemColor: accentTeal,
      unselectedItemColor: textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentTeal;
        }
        return null;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius1),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: accentTeal,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentTeal,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentTeal,
      linearTrackColor: secondaryDark,
      circularTrackColor: secondaryDark,
    ),
    useMaterial3: true,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: primaryLight,
    primaryColor: accentTeal,
    colorScheme: const ColorScheme.light(
      primary: accentTeal,
      secondary: accentLime,
      surface: secondaryLight,
      background: primaryLight,
      error: Colors.redAccent,
      onPrimary: primaryLight,
      onSecondary: primaryLight,
      onSurface: textPrimaryLight,
      onBackground: textPrimaryLight,
      onError: primaryLight,
    ),
    textTheme: GoogleFonts.quicksandTextTheme().copyWith(
      displayLarge: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.quicksand(
        color: textSecondaryLight,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.quicksand(
        color: textSecondaryLight,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      elevation: 0,
      titleTextStyle: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: textPrimaryLight),
    ),
    cardTheme: const CardTheme(
      color: secondaryLight,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        vertical: spacing2,
        horizontal: spacing2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentTeal,
        foregroundColor: primaryLight,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: spacing3,
          horizontal: spacing4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentTeal,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: spacing2,
          horizontal: spacing3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimaryLight,
        side: const BorderSide(color: textSecondaryLight),
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: spacing3,
          horizontal: spacing4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryLight,
      filled: true,
      contentPadding: const EdgeInsets.all(spacing3),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.quicksand(color: textSecondaryLight),
      labelStyle: GoogleFonts.quicksand(color: textSecondaryLight),
    ),
    dividerTheme: const DividerThemeData(
      color: textSecondaryLight,
      thickness: 0.5,
      space: spacing3,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: secondaryLight,
      contentTextStyle: GoogleFonts.quicksand(color: textPrimaryLight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: secondaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius3)),
      ),
      titleTextStyle: GoogleFonts.quicksand(
        color: textPrimaryLight,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      contentTextStyle: GoogleFonts.quicksand(
        color: textPrimaryLight,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: secondaryLight,
      selectedItemColor: accentTeal,
      unselectedItemColor: textSecondaryLight,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentTeal;
        }
        return null;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius1),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: accentTeal,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: accentTeal,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentTeal,
      linearTrackColor: secondaryLight,
      circularTrackColor: secondaryLight,
    ),
    useMaterial3: true,
  );
} 