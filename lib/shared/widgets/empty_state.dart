import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'primary_button.dart';

/// Empty state premium con ilustración y CTA
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
  });

  /// Empty state para cuando no hay recibos
  factory EmptyState.noReceipts({VoidCallback? onScan}) {
    return EmptyState(
      emoji: '📸',
      title: 'Sin recibos aún',
      description: 'Escanea tu primer recibo para empezar a trackear tus gastos como un pro.',
      buttonText: 'Escanear recibo',
      onButtonPressed: onScan,
    );
  }

  /// Empty state para cuando no hay gastos este mes
  factory EmptyState.noExpenses({VoidCallback? onAdd}) {
    return EmptyState(
      emoji: '💰',
      title: 'Mes tranquilo',
      description: 'No tienes gastos registrados este mes. ¡Eso es bueno... o tal vez olvidaste registrarlos!',
      buttonText: 'Agregar gasto',
      onButtonPressed: onAdd,
    );
  }

  /// Empty state para búsqueda sin resultados
  factory EmptyState.noResults() {
    return const EmptyState(
      emoji: '🔍',
      title: 'Nada encontrado',
      description: 'Intenta con otros términos de búsqueda o ajusta los filtros.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji ilustración
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: AppSpacing.xl),

            // Título
            Text(
              title,
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: AppSpacing.sm),

            // Descripción
            Text(
              description,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),

              // CTA Button
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  text: buttonText!,
                  onPressed: onButtonPressed,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2),
            ],
          ],
        ),
      ),
    );
  }
}
