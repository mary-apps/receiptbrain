import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/scanner/view/scanner_screen.dart';
import '../../features/expenses/view/expenses_screen.dart';

/// Rutas de la aplicación
class AppRoutes {
  static const String dashboard = '/';
  static const String scanner = '/scanner';
  static const String expenses = '/expenses';
  static const String expenseDetail = '/expense/:id';
  static const String stats = '/stats';
  static const String settings = '/settings';
}

/// Router de la aplicación
final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    // Dashboard
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // Scanner
    GoRoute(
      path: AppRoutes.scanner,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ScannerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    ),

    // Expenses list
    GoRoute(
      path: AppRoutes.expenses,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ExpensesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);

/// Shell con bottom navigation
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      // La bottom nav se maneja dentro de cada pantalla como Stack
    );
  }
}
