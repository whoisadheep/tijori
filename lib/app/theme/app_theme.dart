import 'package:flutter/material.dart';
import 'package:tijori/app/theme/app_colors.dart';

abstract final class AppTheme {
  // ==========================================
  // LIGHT THEME: Warm Cream Mocha + Champagne Gold + Burnt Amber Highlights
  // ==========================================
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.mochaSurface,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.mochaPrimary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.mochaContainer,
      onPrimaryContainer: AppColors.mochaPrimary,

      secondary: AppColors.champagneDark,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.champagneLight,
      onSecondaryContainer: AppColors.champagneOn,

      tertiary: AppColors.burntAmber,
      onTertiary: AppColors.burntAmberOn,
      tertiaryContainer: AppColors.burntAmberLight,
      onTertiaryContainer: AppColors.burntAmberDark,

      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      surface: AppColors.mochaSurface,
      onSurface: AppColors.mochaText,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF7F2EE),
      surfaceContainer: AppColors.mochaContainer,
      surfaceContainerHigh: Color(0xFFEBE3DE),
      surfaceContainerHighest: Color(0xFFE3D9D3),

      outline: AppColors.mochaMedium,
      outlineVariant: AppColors.mochaBorder,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mochaSurface,
      foregroundColor: AppColors.mochaPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        color: AppColors.mochaPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.mochaBorder, width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.mochaBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.mochaBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.burntAmber, width: 2),
      ),
      isDense: true,
      labelStyle: const TextStyle(color: AppColors.mochaMedium),
      hintStyle: const TextStyle(color: Color(0xFF9E8B83)),
    ),

    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.mochaDark,
      indicatorColor: AppColors.champagneGold,
      selectedIconTheme: IconThemeData(color: AppColors.champagneOn),
      unselectedIconTheme: IconThemeData(color: Color(0xFFB3A199)),
      selectedLabelTextStyle: TextStyle(
        color: AppColors.champagneGlow,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: Color(0xFFB3A199),
        fontSize: 12,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.burntAmber,
      foregroundColor: Colors.white,
      elevation: 3,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mochaPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.champagneGold,
        foregroundColor: AppColors.champagneOn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.mochaContainer,
      selectedColor: AppColors.champagneLight,
      side: const BorderSide(color: AppColors.mochaBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: const TextStyle(color: AppColors.mochaText, fontSize: 13),
    ),
  );

  // ==========================================
  // DARK THEME: Deep Mocha Roast + Glowing Champagne Gold + Burnt Amber Highlights
  // ==========================================
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.mochaDarkest,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.champagneGlow,
      onPrimary: AppColors.champagneOn,
      primaryContainer: Color(0xFF4A3816),
      onPrimaryContainer: AppColors.champagneLight,

      secondary: Color(0xFFD4C1B7),
      onSecondary: AppColors.mochaDarkest,
      secondaryContainer: AppColors.mochaDarkElevated,
      onSecondaryContainer: Color(0xFFF3ECE8),

      tertiary: AppColors.burntAmberGlow,
      onTertiary: AppColors.burntAmberOn,
      tertiaryContainer: Color(0xFF5A2508),
      onTertiaryContainer: Color(0xFFFFDBC9),

      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),

      surface: AppColors.mochaDarkest,
      onSurface: Color(0xFFF0EAE5),
      surfaceContainerLowest: Color(0xFF140D0C),
      surfaceContainerLow: Color(0xFF1E1513),
      surfaceContainer: AppColors.mochaDark,
      surfaceContainerHigh: AppColors.mochaDarkElevated,
      surfaceContainerHighest: Color(0xFF402E29),

      outline: Color(0xFF755E56),
      outlineVariant: Color(0xFF3B2C27),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mochaDarkest,
      foregroundColor: AppColors.champagneGlow,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        color: AppColors.champagneGlow,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.mochaDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF382924), width: 1),
      ),
      margin: const EdgeInsets.all(8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mochaDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF48352F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF48352F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.burntAmberGlow, width: 2),
      ),
      isDense: true,
      labelStyle: const TextStyle(color: Color(0xFFB5A39B)),
      hintStyle: const TextStyle(color: Color(0xFF7D6C64)),
    ),

    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.mochaDarkest,
      indicatorColor: AppColors.champagneGold,
      selectedIconTheme: IconThemeData(color: AppColors.champagneOn),
      unselectedIconTheme: IconThemeData(color: Color(0xFF8E7A71)),
      selectedLabelTextStyle: TextStyle(
        color: AppColors.champagneGlow,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: Color(0xFF8E7A71),
        fontSize: 12,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.burntAmber,
      foregroundColor: Colors.white,
      elevation: 3,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.champagneGold,
        foregroundColor: AppColors.champagneOn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.burntAmber,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.mochaDark,
      selectedColor: const Color(0xFF4A3816),
      side: const BorderSide(color: Color(0xFF382924)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: const TextStyle(color: Color(0xFFF0EAE5), fontSize: 13),
    ),
  );
}
