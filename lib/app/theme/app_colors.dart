import 'package:flutter/material.dart';

/// Design tokens for Tijori Jewellery ERP.
/// Palette:
/// - Mocha Brown (Grounding luxury, deep leather & espresso tones)
/// - Champagne Gold (Refined metallic luster, elegance, jewelry accents)
/// - Burnt Amber (Fiery warmth, key CTA highlights, focal points)
abstract final class AppColors {
  // --- 1. Mocha Brown Palette ---
  /// Darkest roasted mocha for dark-mode scaffold backgrounds
  static const mochaDarkest = Color(0xFF18110F);

  /// Deep mocha surface for dark-mode cards & sidebar
  static const mochaDark = Color(0xFF251A17);

  /// Elevated mocha surface in dark mode
  static const mochaDarkElevated = Color(0xFF332420);

  /// Signature rich mocha brown for light mode primary headers & branding
  static const mochaPrimary = Color(0xFF432C26);

  /// Soft warm mocha for secondary text and borders
  static const mochaMedium = Color(0xFF6E5149);

  /// Light warm mocha tint for input fills and chips
  static const mochaLight = Color(0xFFEFE8E4);

  /// Warm ivory/cream tinted scaffold background for light mode
  static const mochaSurface = Color(0xFFFAF7F5);

  /// Subtle container background for cards and panels
  static const mochaContainer = Color(0xFFF3ECE7);

  /// Muted mocha outline border
  static const mochaBorder = Color(0xFFDFD4CD);

  /// High-contrast mocha text
  static const mochaText = Color(0xFF221613);

  // --- 2. Champagne Gold Palette ---
  /// Core Champagne Gold (refined metallic gold, not garish yellow)
  static const champagneGold = Color(0xFFD4AF37);

  /// Glowing champagne gold for dark mode accents and active indicators
  static const champagneGlow = Color(0xFFE5C875);

  /// Deep antique champagne gold for high-contrast light mode accents
  static const champagneDark = Color(0xFFA07B23);

  /// Soft champagne cream for badges, chip backgrounds, and highlights
  static const champagneLight = Color(0xFFFBF4E2);

  /// Champagne border outline
  static const champagneBorder = Color(0xFFDFCA94);

  /// Dark contrast text when resting on Champagne Gold surfaces
  static const champagneOn = Color(0xFF2C1E03);

  // --- 3. Burnt Amber Highlight Palette ---
  /// Signature Burnt Amber — the primary attention grabber / highlight
  static const burntAmber = Color(0xFFD96726);

  /// Glowing burnt amber for dark mode emphasis
  static const burntAmberGlow = Color(0xFFEB7532);

  /// Deep burnt amber for text and high-contrast badges
  static const burntAmberDark = Color(0xFF9E420C);

  /// Soft burnt amber wash for pill containers and alerts
  static const burntAmberLight = Color(0xFFFEEFE6);

  /// High contrast white text for buttons & chips
  static const burntAmberOn = Color(0xFFFFFFFF);

  // --- 4. Metal & Accounting Semantics ---
  static const goldRate = champagneGold;
  static const silverRate = Color(0xFF78909C);
  static const cashGreen = Color(0xFF2E7D32);
}
