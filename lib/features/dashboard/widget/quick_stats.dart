import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/animated_number.dart';

/// Fila de estadísticas rápidas
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            icon: LucideIcons.receipt,
            label: 'Recibos',
            value: 23,
            color: AppColors.accent,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickStatCard(
            icon: LucideIcons.flame,
            label: 'Racha',
            value: 7,
            suffix: ' días',
            color: AppColors.warning,
          ).animate().fadeIn(delay: 260.ms).slideX(begin: -0.1),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickStatCard(
            icon: LucideIcons.target,
            label: 'Ahorro',
            value: 15,
            suffix: '%',
            color: AppColors.success,
          ).animate().fadeIn(delay: 320.ms).slideX(begin: -0.1),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final String? suffix;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Value
          AnimatedNumber(
            value: value,
            style: AppTypography.display3.copyWith(fontSize: 24),
            suffix: suffix,
            decimalPlaces: 0,
            duration: const Duration(milliseconds: 1000),
          ),

          const SizedBox(height: 4),

          // Label
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Card de estadística más grande para secciones
class StatCard extends StatelessWidget {
  final String title;
  final double value;
  final String? prefix;
  final String? suffix;
  final IconData icon;
  final Color color;
  final double? changePercent;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.prefix,
    this.suffix,
    required this.icon,
    required this.color,
    this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              if (changePercent != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (changePercent! >= 0 ? AppColors.success : AppColors.error)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '${changePercent! >= 0 ? '+' : ''}${changePercent!.toStringAsFixed(1)}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: changePercent! >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          AnimatedNumber(
            value: value,
            style: AppTypography.display3,
            prefix: prefix,
            suffix: suffix,
            decimalPlaces: prefix == '\$' ? 2 : 0,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            title,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
