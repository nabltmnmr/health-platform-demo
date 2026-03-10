import 'package:flutter/material.dart';

/// Assist Health Institute color palette.
/// Soft, calm, institutional healthcare feel.
abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFF8F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EFEC);

  // Primary — muted teal-blue
  static const Color primary = Color(0xFF2D6A6F);
  static const Color primaryContainer = Color(0xFFB8D4D6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0D3235);

  // Secondary — deeper slate-blue
  static const Color secondary = Color(0xFF3D5A6C);
  static const Color secondaryContainer = Color(0xFFD0E0E8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1A2D3A);

  // Semantic
  static const Color success = Color(0xFF4A7C59);
  static const Color successContainer = Color(0xFFD4EDDA);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF1B3D26);

  static const Color warning = Color(0xFFB8860B);
  static const Color warningContainer = Color(0xFFF5E6C4);
  static const Color onWarning = Color(0xFF2D2200);
  static const Color onWarningContainer = Color(0xFF3D3000);

  static const Color danger = Color(0xFFB54A4A);
  static const Color dangerContainer = Color(0xFFF5DADA);
  static const Color onDanger = Color(0xFFFFFFFF);
  static const Color onDangerContainer = Color(0xFF3D1A1A);

  // Text
  static const Color textPrimary = Color(0xFF1C2528);
  static const Color textSecondary = Color(0xFF5C6568);
  static const Color textTertiary = Color(0xFF8A9194);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Borders / dividers
  static const Color outline = Color(0xFFD4D6D5);
  static const Color outlineVariant = Color(0xFFE8E9E8);
}
