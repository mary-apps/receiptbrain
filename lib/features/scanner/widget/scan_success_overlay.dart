import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Overlay de éxito al escanear recibo
/// Con animación de checkmark y confetti sutil
class ScanSuccessOverlay extends StatefulWidget {
  const ScanSuccessOverlay({super.key});

  @override
  State<ScanSuccessOverlay> createState() => _ScanSuccessOverlayState();
}

class _ScanSuccessOverlayState extends State<ScanSuccessOverlay>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Start animations
    _checkController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background.withOpacity(0.9),
      child: Stack(
        children: [
          // Confetti particles
          ..._buildConfetti(),

          // Success content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success circle with checkmark
                _buildSuccessIcon(),

                const SizedBox(height: AppSpacing.xl),

                // Success text
                Text(
                  '¡Recibo escaneado!',
                  style: AppTypography.heading1,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: 0.2),

                const SizedBox(height: AppSpacing.sm),

                // Amount detected
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$',
                      style: AppTypography.display2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '156.80',
                      style: AppTypography.display1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 400.ms)
                    .scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: AppSpacing.md),

                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.categoryFood.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                      color: AppColors.categoryFood.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.utensils,
                        size: 16,
                        color: AppColors.categoryFood,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Restaurante',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.categoryFood,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 400.ms)
                    .slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return AnimatedBuilder(
      animation: _checkController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withOpacity(0.4 * _checkController.value),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success,
                    AppColors.success.withOpacity(0.8),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _CheckmarkPainter(
                  progress: _checkController.value,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  List<Widget> _buildConfetti() {
    final random = math.Random(42);
    final particles = <Widget>[];

    for (var i = 0; i < 20; i++) {
      final startX = random.nextDouble() * MediaQuery.of(context).size.width;
      final startY = MediaQuery.of(context).size.height * 0.3;
      final endX = startX + (random.nextDouble() - 0.5) * 200;
      final delay = random.nextInt(500);

      particles.add(
        AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            final progress = _confettiController.value;
            final y = startY + (progress * MediaQuery.of(context).size.height * 0.6);
            final x = startX + ((endX - startX) * progress);
            final opacity = (1 - progress).clamp(0.0, 1.0);
            final rotation = progress * math.pi * 4;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: rotation,
                  child: Container(
                    width: 8 + random.nextDouble() * 8,
                    height: 8 + random.nextDouble() * 8,
                    decoration: BoxDecoration(
                      color: _getConfettiColor(random.nextInt(5)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return particles;
  }

  Color _getConfettiColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.categoryFood,
      AppColors.categoryShopping,
      AppColors.categoryEntertainment,
    ];
    return colors[index % colors.length];
  }
}

/// Painter para el checkmark animado
class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Checkmark points (relative to center)
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final startPoint = Offset(centerX - 16, centerY);
    final midPoint = Offset(centerX - 4, centerY + 12);
    final endPoint = Offset(centerX + 18, centerY - 10);

    // First stroke (start to mid)
    final firstStrokeProgress = (progress * 2).clamp(0.0, 1.0);
    if (firstStrokeProgress > 0) {
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(
        startPoint.dx + (midPoint.dx - startPoint.dx) * firstStrokeProgress,
        startPoint.dy + (midPoint.dy - startPoint.dy) * firstStrokeProgress,
      );
    }

    // Second stroke (mid to end)
    final secondStrokeProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
    if (secondStrokeProgress > 0) {
      path.moveTo(midPoint.dx, midPoint.dy);
      path.lineTo(
        midPoint.dx + (endPoint.dx - midPoint.dx) * secondStrokeProgress,
        midPoint.dy + (endPoint.dy - midPoint.dy) * secondStrokeProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
