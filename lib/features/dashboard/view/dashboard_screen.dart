import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/widgets.dart';
import '../widget/expense_chart.dart';
import '../widget/category_card.dart';
import '../widget/quick_stats.dart';

/// Dashboard principal — La pantalla que hace "WOW"
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Haptic feedback al entrar
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient
          _buildBackground(),

          // Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                // Hero Card — Total del mes
                SliverToBoxAdapter(
                  child: _buildHeroCard(),
                ),

                // Quick Stats Row
                SliverToBoxAdapter(
                  child: _buildQuickStats(),
                ),

                // Expense Chart
                SliverToBoxAdapter(
                  child: _buildExpenseChart(),
                ),

                // Categories Section
                SliverToBoxAdapter(
                  child: _buildCategoriesSection(),
                ),

                // Bottom padding para el FAB y nav
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.scrollBottom + 80),
                ),
              ],
            ),
          ),

          // Scanner FAB
          Positioned(
            right: AppSpacing.screenPadding,
            bottom: MediaQuery.of(context).padding.bottom +
                AppSpacing.bottomNavHeight +
                AppSpacing.xl +
                AppSpacing.lg,
            child: ScannerFAB(
              onPressed: () {
                // TODO: Navigate to scanner
                HapticFeedback.heavyImpact();
              },
            ).animate().fadeIn(delay: 600.ms).scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola! 👋',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Febrero 2026',
                style: AppTypography.heading1,
              ),
            ],
          ),
          // Profile avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.borderDefault,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text('🧠', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: GlassCard(
        showGlow: true,
        glowColor: AppColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total gastado',
                  style: AppTypography.bodyMedium,
                ),
                // Badge de cambio
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.trendingDown,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      const AnimatedPercent(value: -12.5),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Número animado grande
            const AnimatedMoney(
              amount: 12450.00,
              style: null, // Usa moneyLarge por defecto
            ),

            const SizedBox(height: AppSpacing.sm),

            // Presupuesto info
            Row(
              children: [
                Text(
                  'de ',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  '\$20,000',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ' presupuesto',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Progress bar
            _BudgetProgressBar(
              spent: 12450,
              budget: 20000,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 100.ms, duration: 500.ms)
        .slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: const QuickStatsRow(),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildExpenseChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimos 7 días',
            style: AppTypography.heading3,
          ),
          const SizedBox(height: AppSpacing.md),
          const ExpenseBarChart(),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Por categoría',
                style: AppTypography.heading3,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ver todo',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Category cards con stagger animation
          ..._buildCategoryCards(),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryCards() {
    final categories = [
      ('Comida', 3450.00, LucideIcons.utensils, AppColors.categoryFood),
      ('Transporte', 1200.00, LucideIcons.car, AppColors.categoryTransport),
      ('Compras', 2800.00, LucideIcons.shoppingBag, AppColors.categoryShopping),
      ('Entretenimiento', 890.00, LucideIcons.gamepad2, AppColors.categoryEntertainment),
    ];

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final (name, amount, icon, color) = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: CategoryCard(
          name: name,
          amount: amount,
          totalBudget: 12450,
          icon: icon,
          color: color,
        ),
      )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 400 + (index * AppSpacing.staggerDelayMs)),
            duration: 400.ms,
          )
          .slideX(
            begin: 0.1,
            delay: Duration(milliseconds: 400 + (index * AppSpacing.staggerDelayMs)),
            duration: 400.ms,
            curve: Curves.easeOutCubic,
          );
    }).toList();
  }
}

/// Barra de progreso del presupuesto
class _BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double budget;

  const _BudgetProgressBar({
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (spent / budget).clamp(0.0, 1.0);
    final isOverBudget = spent > budget;

    return Column(
      children: [
        // Progress bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surface3,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Filled portion
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isOverBudget
                            ? [AppColors.error, AppColors.error.withOpacity(0.8)]
                            : [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: (isOverBudget ? AppColors.error : AppColors.primary)
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .scaleX(
                        begin: 0,
                        alignment: Alignment.centerLeft,
                        delay: 500.ms,
                        duration: 1000.ms,
                        curve: Curves.easeOutExpo,
                      ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(0)}% usado',
              style: AppTypography.caption,
            ),
            Text(
              '\$${(budget - spent).toStringAsFixed(0)} restante',
              style: AppTypography.caption.copyWith(
                color: isOverBudget ? AppColors.error : AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
