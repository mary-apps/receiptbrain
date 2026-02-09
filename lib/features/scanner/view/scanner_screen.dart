import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../widget/scanning_overlay.dart';
import '../widget/scan_success_overlay.dart';

/// Estados del scanner
enum ScannerState { idle, scanning, processing, success, error }

/// Provider para el estado del scanner
final scannerStateProvider = StateProvider<ScannerState>((ref) => ScannerState.idle);

/// Pantalla del scanner de recibos
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();

    // Pulse animation para el borde
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Scan line animation
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  void _simulateScan() async {
    final notifier = ref.read(scannerStateProvider.notifier);

    // Start scanning
    notifier.state = ScannerState.scanning;
    HapticFeedback.lightImpact();

    // Simulate scan duration
    await Future.delayed(const Duration(seconds: 2));

    // Processing
    notifier.state = ScannerState.processing;
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Success!
    notifier.state = ScannerState.success;
    HapticFeedback.heavyImpact();

    // Reset after showing success
    await Future.delayed(const Duration(seconds: 2));
    notifier.state = ScannerState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(scannerStateProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Camera preview placeholder (en producción sería CameraPreview)
          _buildCameraPlaceholder(),

          // Scanning frame overlay
          _buildScanningFrame(size, scannerState),

          // Top bar
          _buildTopBar(context),

          // Bottom controls
          _buildBottomControls(scannerState),

          // Scanning overlay (beam animation)
          if (scannerState == ScannerState.scanning)
            ScanningOverlay(controller: _scanLineController),

          // Processing overlay
          if (scannerState == ScannerState.processing)
            _buildProcessingOverlay(),

          // Success overlay
          if (scannerState == ScannerState.success)
            const ScanSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surface1,
            AppColors.background,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.camera,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Vista de cámara',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningFrame(Size size, ScannerState state) {
    final frameWidth = size.width * 0.85;
    final frameHeight = frameWidth * 1.4; // Ratio de recibo

    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseValue = state == ScannerState.scanning
              ? 0.5 + (_pulseController.value * 0.5)
              : 1.0;

          return Container(
            width: frameWidth,
            height: frameHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(
                color: _getFrameColor(state).withOpacity(pulseValue),
                width: 3,
              ),
              boxShadow: state == ScannerState.scanning
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3 * pulseValue),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                // Corner decorations
                ..._buildCorners(state),

                // Center hint
                if (state == ScannerState.idle)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface2.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                LucideIcons.receipt,
                                size: 48,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Alinea el recibo aquí',
                                style: AppTypography.labelLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Asegúrate de que esté bien iluminado',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fadeIn()
                            .then()
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.02, 1.02),
                              duration: 1500.ms,
                            ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Color _getFrameColor(ScannerState state) {
    switch (state) {
      case ScannerState.scanning:
        return AppColors.primary;
      case ScannerState.processing:
        return AppColors.accent;
      case ScannerState.success:
        return AppColors.success;
      case ScannerState.error:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  List<Widget> _buildCorners(ScannerState state) {
    final color = _getFrameColor(state);
    const size = 24.0;
    const thickness = 4.0;

    Widget corner(Alignment alignment) {
      return Positioned(
        top: alignment == Alignment.topLeft || alignment == Alignment.topRight ? 0 : null,
        bottom: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight ? 0 : null,
        left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? 0 : null,
        right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? 0 : null,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: color,
              thickness: thickness,
              alignment: alignment,
            ),
          ),
        ),
      );
    }

    return [
      corner(Alignment.topLeft),
      corner(Alignment.topRight),
      corner(Alignment.bottomLeft),
      corner(Alignment.bottomRight),
    ];
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            _CircleButton(
              icon: LucideIcons.x,
              onTap: () => Navigator.of(context).pop(),
            ),

            // Title
            Text(
              'Escanear recibo',
              style: AppTypography.heading3,
            ),

            // Flash toggle
            _CircleButton(
              icon: LucideIcons.zap,
              onTap: () {
                HapticFeedback.selectionClick();
                // Toggle flash
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2, duration: 400.ms);
  }

  Widget _buildBottomControls(ScannerState state) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xl,
          AppSpacing.screenPadding,
          MediaQuery.of(context).padding.bottom + AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.background.withOpacity(0.8),
              AppColors.background,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Capture button
            GestureDetector(
              onTap: state == ScannerState.idle ? _simulateScan : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state == ScannerState.idle
                      ? AppColors.primary
                      : AppColors.surface3,
                  border: Border.all(
                    color: AppColors.textPrimary.withOpacity(0.3),
                    width: 4,
                  ),
                  boxShadow: state == ScannerState.idle
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: state == ScannerState.idle
                      ? const Icon(
                          LucideIcons.camera,
                          color: AppColors.textPrimary,
                          size: 32,
                        )
                      : SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColors.textSecondary),
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Hint text
            Text(
              state == ScannerState.idle
                  ? 'Toca para capturar'
                  : state == ScannerState.scanning
                      ? 'Escaneando...'
                      : state == ScannerState.processing
                          ? 'Procesando recibo...'
                          : '',
              style: AppTypography.bodyMedium,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Gallery button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  icon: LucideIcons.image,
                  label: 'Galería',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // Open gallery
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 400.ms);
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: AppColors.background.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI brain animation
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🧠', style: TextStyle(fontSize: 48)),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 600.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.easeInOut,
                ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'Analizando recibo...',
              style: AppTypography.heading3,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Extrayendo información con IA',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Botón circular glassmorphic
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface2.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.borderSubtle,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(label!, style: AppTypography.caption),
          ],
        ],
      ),
    );
  }
}

/// Painter para las esquinas del frame
class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final Alignment alignment;

  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.alignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
