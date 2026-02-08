import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Sistema tipográfico premium - Inter
/// letterSpacing negativo en títulos, height definido siempre
class AppTypography {
  AppTypography._();

  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // ═══════════════════════════════════════════════════════════════
  // DISPLAY — Números grandes, hero text
  // ═══════════════════════════════════════════════════════════════

  /// Display 1 — $12,450.00 (números de dashboard)
  static TextStyle get display1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -2.0,
        color: AppColors.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Display 2 — Hero numbers más pequeños
  static TextStyle get display2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Display 3 — Stats cards
  static TextStyle get display3 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -1.0,
        color: AppColors.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // ═══════════════════════════════════════════════════════════════
  // HEADINGS
  // ═══════════════════════════════════════════════════════════════

  /// Heading 1 — Títulos de pantalla
  static TextStyle get heading1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  /// Heading 2 — Secciones
  static TextStyle get heading2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  /// Heading 3 — Subsecciones
  static TextStyle get heading3 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  // ═══════════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════════

  /// Body Large — Texto principal
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: -0.1,
        color: AppColors.textPrimary,
      );

  /// Body Medium — Texto secundario
  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: AppColors.textSecondary,
      );

  /// Body Small — Texto terciario
  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.1,
        color: AppColors.textTertiary,
      );

  // ═══════════════════════════════════════════════════════════════
  // LABELS & CAPTIONS
  // ═══════════════════════════════════════════════════════════════

  /// Label Large — Botones, tabs
  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  /// Label Medium — Tags, badges
  static TextStyle get labelMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );

  /// Label Small — Captions, metadata
  static TextStyle get labelSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
        color: AppColors.textTertiary,
      );

  /// Caption — Helper text
  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.textTertiary,
      );

  // ═══════════════════════════════════════════════════════════════
  // MONEY SPECIFIC
  // ═══════════════════════════════════════════════════════════════

  /// Número de dinero grande
  static TextStyle get moneyLarge => display1.copyWith(
        color: AppColors.primary,
      );

  /// Número de dinero mediano
  static TextStyle get moneyMedium => display3.copyWith(
        color: AppColors.textPrimary,
      );

  /// Número de dinero pequeño en cards
  static TextStyle get moneySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Cambio porcentual (+ o -)
  static TextStyle percentChange(bool isPositive) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: isPositive ? AppColors.success : AppColors.error,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
