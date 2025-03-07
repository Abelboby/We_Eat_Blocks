import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Spacing constants
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 16.0;
  static const double spacing4 = 24.0;
  static const double spacing5 = 32.0;
  static const double spacing6 = 48.0;
  static const double spacing7 = 64.0;

  // Border radius constants
  static const double borderRadius1 = 4.0;
  static const double borderRadius2 = 8.0;
  static const double borderRadius3 = 12.0;
  static const double borderRadius4 = 16.0;
  static const double borderRadius5 = 24.0;
  static const double borderRadiusCircular = 100.0;
  static const double borderRadiusRound =
      100.0; // Alias for backward compatibility

  // Main Theme Colors
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color accentTeal = Color(0xFF76EAD7);
  static const Color accentLime = Color(0xFFC4FB6D);

  // Legacy color constants for backward compatibility
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFFF8FAFC);
  static const Color secondaryLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color accentBlue = Color(0xFF0288D1);
  static const Color accentAmber = Color(0xFFFFB300);

  // Premium colors
  static const Color premiumDarkBlue = Color(0xFF0F172A);
  static const Color premiumLightTeal = Color(0xFF76EAD7);
  static const Color premiumTeal = Color(0xFF76EAD7);
  static const Color premiumLime = Color(0xFFC4FB6D);
  static const Color premiumSilver = Color(0xFFE0E0E0);

  // Premium gradients
  static const List<Color> tealLimeGradient = [premiumTeal, accentLime];
  static const List<Color> darkTealGradient = [primaryDark, premiumTeal];
  static const List<Color> tealLightGradient = [premiumTeal, Colors.white70];

  // Background colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);

  // Card colors
  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF1E293B);

  // Premium card colors
  static const Color lightPremiumCardColor = Color(0xFFFAFAFA);
  static const Color darkPremiumCardColor = Color(0xFF334155);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Legacy animation durations for backward compatibility
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);

  // Create theme instances
  static final ThemeData _cachedLightTheme = _createLightTheme();
  static final ThemeData _cachedDarkTheme = _createDarkTheme();

  // Legacy theme properties for backward compatibility
  static ThemeData get lightTheme => _cachedLightTheme;
  static ThemeData get darkTheme => _cachedDarkTheme;

  // Light theme
  static ThemeData _createLightTheme() {
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      colorScheme: ColorScheme.light(
        primary: accentTeal,
        primaryContainer: accentTeal.withOpacity(0.2),
        secondary: accentLime,
        secondaryContainer: accentLime.withOpacity(0.2),
        surface: lightCardColor,
        background: lightBackground,
        error: Colors.red.shade700,
        onPrimary: primaryDark,
        onSecondary: primaryDark,
        onSurface: textPrimaryLight,
        onBackground: textPrimaryLight,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: accentTeal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryDark,
        ),
        iconTheme: const IconThemeData(color: primaryDark),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightCardColor,
        selectedItemColor: accentTeal,
        unselectedItemColor: textSecondaryLight,
        selectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      cardTheme: CardTheme(
        color: lightCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius3),
        ),
        shadowColor: primaryDark.withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: primaryDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentTeal,
          side: const BorderSide(color: accentTeal, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing3,
            vertical: spacing2,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: accentTeal,
        size: 24,
      ),
      textTheme: GoogleFonts.quicksandTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.quicksand(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        displayMedium: GoogleFonts.quicksand(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        displaySmall: GoogleFonts.quicksand(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        headlineLarge: GoogleFonts.quicksand(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        headlineMedium: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        headlineSmall: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleSmall: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimaryLight,
        ),
        bodySmall: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        labelSmall: GoogleFonts.quicksand(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCardColor,
        contentPadding: const EdgeInsets.all(spacing3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textSecondaryLight,
        ),
        hintStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight.withOpacity(0.7),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: spacing3,
      ),
    );
  }

  // Dark theme
  static ThemeData _createDarkTheme() {
    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: accentTeal,
        primaryContainer: accentTeal.withOpacity(0.2),
        secondary: accentLime,
        secondaryContainer: accentLime.withOpacity(0.2),
        surface: darkCardColor,
        background: darkBackground,
        error: Colors.red.shade700,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: secondaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: secondaryDark,
        selectedItemColor: accentTeal,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      cardTheme: CardTheme(
        color: secondaryDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius3),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: primaryDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentTeal,
          side: const BorderSide(color: accentTeal, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing3,
            vertical: spacing2,
          ),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: accentTeal,
        size: 24,
      ),
      textTheme: GoogleFonts.quicksandTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.quicksand(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.quicksand(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.quicksand(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.quicksand(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelSmall: GoogleFonts.quicksand(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryDark,
        contentPadding: const EdgeInsets.all(spacing3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius2),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        hintStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary.withOpacity(0.7),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: spacing3,
      ),
    );
  }

  // Public theme methods
  static ThemeData getLightTheme() => _cachedLightTheme;
  static ThemeData getDarkTheme() => _cachedDarkTheme;
}
