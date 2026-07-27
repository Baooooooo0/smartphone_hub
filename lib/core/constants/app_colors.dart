import 'package:flutter/material.dart';

/// AppColors — Bảng màu chính của SmartphoneHub
/// Primary: Tech Blue, điện thoại cao cấp, hiện đại
abstract class AppColors {
  // ─── Primary Brand ────────────────────────────────────────────
  static const Color primary = Color(0xFF0057FF);
  static const Color primaryLight = Color(0xFF4D8AFF);
  static const Color primaryDark = Color(0xFF0041CC);
  static const Color primarySurface = Color(0xFFE8F0FF);

  // ─── Secondary / Accent ──────────────────────────────────────
  static const Color secondary = Color(0xFF00D4FF);
  static const Color secondaryDark = Color(0xFF0099CC);

  // ─── Semantic Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF00C48C);
  static const Color successSurface = Color(0xFFE6FAF5);
  static const Color warning = Color(0xFFFFB800);
  static const Color warningSurface = Color(0xFFFFF8E1);
  static const Color error = Color(0xFFFF4D4F);
  static const Color errorSurface = Color(0xFFFFEDED);
  static const Color info = Color(0xFF1890FF);

  // ─── Neutrals (Light Theme) ──────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFE4E7EC);
  static const Color divider = Color(0xFFF0F2F5);

  // ─── Text ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Price / Sale ────────────────────────────────────────────
  static const Color priceColor = Color(0xFFFF3B3B);
  static const Color originalPrice = Color(0xFF9CA3AF);
  static const Color discountBadge = Color(0xFFFF3B3B);

  // ─── Rating ──────────────────────────────────────────────────
  static const Color starColor = Color(0xFFFFB800);

  // ─── Status Colors (Order) ───────────────────────────────────
  static const Color statusPending = Color(0xFFFFB800);
  static const Color statusConfirmed = Color(0xFF0057FF);
  static const Color statusShipping = Color(0xFF7B61FF);
  static const Color statusDelivered = Color(0xFF00C48C);
  static const Color statusCancelled = Color(0xFFFF4D4F);

  // ─── Gradient ────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0057FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1D2E), Color(0xFF2D3250)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Shadow ──────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get primaryShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
