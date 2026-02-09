import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/widgets.dart';
import '../widget/expense_item.dart';
import '../widget/filter_chips.dart';

/// Lista de gastos — Cards coloridas con stagger animation
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _selectedFilter = 'all';
  final _searchController = TextEditingController();
  bool _isSearching = false;

  // Datos de ejemplo
  final _expenses = [
    _ExpenseData(
      id: '1',
      merchant: 'Starbucks',
      category: 'Comida',
      amount: 156.80,
      date: DateTime.now(),
      icon: LucideIcons.coffee,
    ),
    _ExpenseData(
      id: '2',
      merchant: 'Uber',
      category: 'Transporte',
      amount: 89.50,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      icon: LucideIcons.car,
    ),
    _ExpenseData(
      id: '3',
      merchant: 'Amazon',
      category: 'Compras',
      amount: 1249.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: LucideIcons.shoppingBag,
    ),
    _ExpenseData(
      id: '4',
      merchant: 'Netflix',
      category: 'Entretenimiento',
      amount: 199.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: LucideIcons.tv,
    ),
    _ExpenseData(
      id: '5',
      merchant: 'Farmacia del Ahorro',
      category: 'Salud',
      amount: 345.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: LucideIcons.pill,
    ),
    _ExpenseData(
      id: '6',
      merchant: 'Restaurante Italiano',
      category: 'Comida',
      amount: 780.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: LucideIcons.utensils,
    ),
    _ExpenseData(
      id: '7',
      merchant: 'Gasolinera',
      category: 'Transporte',
      amount: 650.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      icon: LucideIcons.fuel,
    ),
    _ExpenseData(
      id: '8',
      merchant: 'Spotify',
      category: 'Entretenimiento',
      amount: 115.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      icon: LucideIcons.music,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ExpenseData> get _filteredExpenses {
    var filtered = _expenses;

    if (_selectedFilter != 'all') {
      filtered = filtered.where((e) => e.category == _selectedFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((e) =>
          e.merchant.toLowerCase().contains(query) ||
          e.category.toLowerCase().contains(query)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Search bar
            _buildSearchBar(),

            // Filter chips
            FilterChipsRow(
              selected: _selectedFilter,
              onSelected: (filter) {
                HapticFeedback.selectionClick();
                setState(() => _selectedFilter = filter);
              },
            ),

            // Expenses list
            Expanded(
              child: _filteredExpenses.isEmpty
                  ? EmptyState.noResults()
                  : _buildExpensesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gastos',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 4),
              Text(
                '${_expenses.length} transacciones',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),

          // Month total
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.wallet,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '\$${_expenses.fold<double>(0, (sum, e) => sum + e.amount).toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.1, duration: 400.ms);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: _isSearching ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            Icon(
              LucideIcons.search,
              size: 20,
              color: _isSearching ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Buscar gastos...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) => setState(() {}),
                onTap: () => setState(() => _isSearching = true),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  setState(() => _isSearching = false);
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    LucideIcons.x,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 100.ms, duration: 400.ms)
        .slideY(begin: 0.1, duration: 400.ms);
  }

  Widget _buildExpensesList() {
    // Group by date
    final grouped = <String, List<_ExpenseData>>{};
    for (final expense in _filteredExpenses) {
      final dateKey = _formatDateHeader(expense.date);
      grouped.putIfAbsent(dateKey, () => []).add(expense);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      itemCount: grouped.length,
      itemBuilder: (context, groupIndex) {
        final dateKey = grouped.keys.elementAt(groupIndex);
        final expenses = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                dateKey,
                style: AppTypography.labelMedium,
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: groupIndex * 100),
                  duration: 300.ms,
                ),

            // Expense items
            ...expenses.asMap().entries.map((entry) {
              final index = entry.key;
              final expense = entry.value;
              final globalIndex = _filteredExpenses.indexOf(expense);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ExpenseItem(
                  merchant: expense.merchant,
                  category: expense.category,
                  amount: expense.amount,
                  date: expense.date,
                  icon: expense.icon,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // Navigate to detail
                  },
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(
                      milliseconds: 200 + (globalIndex * AppSpacing.staggerDelayMs),
                    ),
                    duration: 400.ms,
                  )
                  .slideX(
                    begin: 0.05,
                    delay: Duration(
                      milliseconds: 200 + (globalIndex * AppSpacing.staggerDelayMs),
                    ),
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  );
            }),
          ],
        );
      },
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Ayer';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ExpenseData {
  final String id;
  final String merchant;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;

  _ExpenseData({
    required this.id,
    required this.merchant,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
  });
}
