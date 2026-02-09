import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Fila de chips de filtro por categoría
class FilterChipsRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const FilterChipsRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _filters = [
    _FilterData('all', 'Todos', LucideIcons.layoutGrid, null),
    _FilterData('Comida', 'Comida', LucideIcons.utensils, AppColors.categoryFood),
    _FilterData('Transporte', 'Transporte', LucideIcons.car, AppColors.categoryTransport),
    _FilterData('Compras', 'Compras', LucideIcons.shoppingBag, AppColors.categoryShopping),
    _FilterData('Entretenimiento', 'Ocio', LucideIcons.gamepad2, AppColors.categoryEntertainment),
    _FilterData('Salud', 'Salud', LucideIcons.pill, AppColors.categoryHealth),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selected == filter.id;

          return _FilterChip(
            label: filter.label,
            icon: filter.icon,
            color: filter.color,
            isSelected: isSelected,
            onTap: () => onSelected(filter.id),
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 150 + (index * 50)),
                duration: 300.ms,
              )
              .slideX(
                begin: 0.1,
                delay: Duration(milliseconds: 150 + (index * 50)),
                duration: 300.ms,
              );
        },
      ),
    );
  }
}

class _FilterData {
  final String id;
  final String label;
  final IconData icon;
  final Color? color;

  const _FilterData(this.id, this.label, this.icon, this.color);
}

class _FilterChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? effectiveColor.withOpacity(0.15)
                : AppColors.surface2,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: widget.isSelected
                  ? effectiveColor.withOpacity(0.3)
                  : AppColors.borderSubtle,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: effectiveColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isSelected
                    ? effectiveColor
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.label,
                style: AppTypography.labelMedium.copyWith(
                  color: widget.isSelected
                      ? effectiveColor
                      : AppColors.textSecondary,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
