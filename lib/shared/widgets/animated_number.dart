import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

/// Número que se anima desde 0 hasta el valor final
/// Perfecto para dashboards de dinero
class AnimatedNumber extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final int decimalPlaces;
  final Duration duration;
  final Curve curve;
  final bool useGrouping;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.style,
    this.prefix,
    this.suffix,
    this.decimalPlaces = 2,
    this.duration = const Duration(milliseconds: AppSpacing.countDurationMs),
    this.curve = Curves.easeOutExpo,
    this.useGrouping = true,
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: widget.prefix ?? '',
      decimalDigits: widget.decimalPlaces,
    );

    String formatted = formatter.format(value);

    // Si no queremos el símbolo de moneda como prefijo
    if (widget.prefix == null) {
      formatted = NumberFormat.decimalPatternDigits(
        locale: 'en_US',
        decimalDigits: widget.decimalPlaces,
      ).format(value);
    }

    if (widget.suffix != null) {
      formatted += widget.suffix!;
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _formatNumber(_animation.value),
          style: widget.style ?? AppTypography.display1,
        );
      },
    );
  }
}

/// Número de dinero animado con símbolo de moneda
class AnimatedMoney extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final String currency;
  final bool showCents;
  final Duration? duration;

  const AnimatedMoney({
    super.key,
    required this.amount,
    this.style,
    this.currency = '\$',
    this.showCents = true,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedNumber(
      value: amount,
      style: style ?? AppTypography.moneyLarge,
      prefix: currency,
      decimalPlaces: showCents ? 2 : 0,
      duration: duration ?? const Duration(milliseconds: AppSpacing.countDurationMs),
    );
  }
}

/// Porcentaje animado con indicador de cambio
class AnimatedPercent extends StatelessWidget {
  final double value;
  final bool showSign;

  const AnimatedPercent({
    super.key,
    required this.value,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final sign = showSign ? (isPositive ? '+' : '') : '';

    return AnimatedNumber(
      value: value,
      style: AppTypography.percentChange(isPositive),
      prefix: sign,
      suffix: '%',
      decimalPlaces: 1,
      duration: const Duration(milliseconds: 800),
    );
  }
}
