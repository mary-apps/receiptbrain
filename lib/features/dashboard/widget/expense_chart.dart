import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';

/// Gráfico de barras de gastos últimos 7 días
/// Con animación de entrada premium
class ExpenseBarChart extends StatefulWidget {
  const ExpenseBarChart({super.key});

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  int? _touchedIndex;

  // Datos de ejemplo - en producción vendrían del provider
  final List<_DayData> _data = [
    _DayData('Lun', 450),
    _DayData('Mar', 280),
    _DayData('Mié', 620),
    _DayData('Jue', 180),
    _DayData('Vie', 890),
    _DayData('Sáb', 1200),
    _DayData('Hoy', 340),
  ];

  @override
  Widget build(BuildContext context) {
    final maxValue = _data.map((d) => d.amount).reduce((a, b) => a > b ? a : b);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue * 1.2,
                minY: 0,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() {
                      if (response == null || response.spot == null) {
                        _touchedIndex = null;
                      } else {
                        _touchedIndex = response.spot!.touchedBarGroupIndex;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surface3,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(0)}',
                        AppTypography.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= _data.length) {
                          return const SizedBox();
                        }
                        final isToday = index == _data.length - 1;
                        final isTouched = _touchedIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            _data[index].day,
                            style: AppTypography.caption.copyWith(
                              color: isToday || isTouched
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                              fontWeight: isToday || isTouched
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: _data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final isTouched = _touchedIndex == index;
                  final isToday = index == _data.length - 1;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.amount,
                        width: 28,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isTouched || isToday
                              ? [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ]
                              : [
                                  AppColors.primary.withOpacity(0.4),
                                  AppColors.primary.withOpacity(0.6),
                                ],
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxValue * 1.2,
                          color: AppColors.surface3.withOpacity(0.3),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .scaleY(
                begin: 0,
                alignment: Alignment.bottomCenter,
                delay: 200.ms,
                duration: 800.ms,
                curve: Curves.easeOutCubic,
              ),

          const SizedBox(height: AppSpacing.md),

          // Total de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total semana',
                    style: AppTypography.caption,
                  ),
                  Text(
                    '\$${_data.fold<double>(0, (sum, d) => sum + d.amount).toStringAsFixed(0)}',
                    style: AppTypography.moneySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Promedio diario',
                    style: AppTypography.caption,
                  ),
                  Text(
                    '\$${(_data.fold<double>(0, (sum, d) => sum + d.amount) / _data.length).toStringAsFixed(0)}',
                    style: AppTypography.moneySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayData {
  final String day;
  final double amount;

  _DayData(this.day, this.amount);
}
