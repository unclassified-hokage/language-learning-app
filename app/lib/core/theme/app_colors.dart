import 'package:flutter/material.dart';

/// LinguAI colour system
/// Dark-first design with cultural accent colours per language
class AppColors {
  AppColors._();

  // ── Core backgrounds ──────────────────────────────────────────────
  static const Color background = Color(0xFF1A1A2E);       // Deep navy
  static const Color surface = Color(0xFF16213E);           // Midnight blue
  static const Color surfaceVariant = Color(0xFF0F3460);    // Ocean blue
  static const Color surfaceGlass = Color(0x2216213E);      // Glassmorphism (14% opacity)

  // ── Primary brand ─────────────────────────────────────────────────
  static const Color primary = Color(0xFFE94560);           // Coral red
  static const Color primaryLight = Color(0xFFFF6B81);
  static const Color primaryDark = Color(0xFFC0303F);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8D4);
  static const Color textMuted = Color(0xFF6B7A99);

  // ── Functional ────────────────────────────────────────────────────
  static const Color correct = Color(0xFF4CAF82);           // Success green
  static const Color error = Color(0xFFFF6B6B);             // Soft red (not aggressive)
  static const Color warning = Color(0xFFFFB74D);
  static const Color xpGold = Color(0xFFFFD700);

  // ── Light mode ────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F5F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF4A5568);

  // ── Language accent colours ───────────────────────────────────────
  static const Map<String, Color> languageAccents = {
    'es': Color(0xFFC60B1E), // Spanish — flag red
    'fr': Color(0xFF0055A4), // French — flag blue
    'ja': Color(0xFFBC002D), // Japanese — flag red
    'ko': Color(0xFF003478), // Korean — Taegukgi blue
    'de': Color(0xFFFFCE00), // German — flag gold
    'it': Color(0xFF009246), // Italian — flag green
    'pt': Color(0xFF006600), // Portuguese — flag green
    'zh': Color(0xFFDE2910), // Mandarin — flag red
    'ar': Color(0xFF006233), // Arabic — flag green
    'ru': Color(0xFF0039A6), // Russian — flag blue
  };

  static Color accentFor(String languageCode) =>
      languageAccents[languageCode] ?? primary;

  // ── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x3316213E), Color(0x1A0F3460)],
  );

  static LinearGradient accentGradient(String languageCode) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentFor(languageCode).withOpacity(0.8),
          accentFor(languageCode).withOpacity(0.4),
        ],
      );
}
