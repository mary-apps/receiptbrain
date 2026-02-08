import 'dart:ui';

/// Paleta de colores ReceiptBrain — Profesional y Confiable
/// Primary: Esmeralda #10B981 | Accent: Azul #3B82F6
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // PRIMARY COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Esmeralda principal - éxito, dinero, confianza
  static const Color primary = Color(0xFF10B981);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF059669);

  /// Azul accent - acciones, links, información
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentLight = Color(0xFF60A5FA);
  static const Color accentDark = Color(0xFF2563EB);

  // ═══════════════════════════════════════════════════════════════
  // SURFACE LAYERS (de más profundo a más elevado)
  // ═══════════════════════════════════════════════════════════════

  /// Fondo principal - negro con tinte verdoso
  static const Color background = Color(0xFF0B0D0F);
  
  /// Surface nivel 1 - cards base
  static const Color surface1 = Color(0xFF12151A);
  
  /// Surface nivel 2 - cards elevadas
  static const Color surface2 = Color(0xFF1A1F26);
  
  /// Surface nivel 3 - elementos flotantes
  static const Color surface3 = Color(0xFF242B35);
  
  /// Overlay para modals
  static const Color surfaceOverlay = Color(0xFF2E3744);

  // ═══════════════════════════════════════════════════════════════
  // BORDERS
  // ═══════════════════════════════════════════════════════════════

  static const Color borderSubtle = Color(0x15FFFFFF);   // 8%
  static const Color borderDefault = Color(0x20FFFFFF);  // 12%
  static const Color borderStrong = Color(0x30FFFFFF);   // 19%

  // ═══════════════════════════════════════════════════════════════
  // TEXT
  // ═══════════════════════════════════════════════════════════════

  /// Texto primario - NO blanco puro
  static const Color textPrimary = Color(0xFFF0F2F5);
  
  /// Texto secundario
  static const Color textSecondary = Color(0xFF8A919E);
  
  /// Texto terciario / placeholders
  static const Color textTertiary = Color(0xFF555D6B);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY COLORS (para gastos)
  // ═══════════════════════════════════════════════════════════════

  static const Color categoryFood = Color(0xFFFF6B6B);       // Comida - rojo coral
  static const Color categoryTransport = Color(0xFF4ECDC4);  // Transporte - turquesa
  static const Color categoryShopping = Color(0xFFFFE66D);   // Compras - amarillo
  static const Color categoryBills = Color(0xFF95E1D3);      // Facturas - mint
  static const Color categoryHealth = Color(0xFFFF8B94);     // Salud - rosa
  static const Color categoryEntertainment = Color(0xFFA78BFA); // Entretenimiento - violeta
  static const Color categoryTravel = Color(0xFF60A5FA);     // Viajes - azul
  static const Color categoryOther = Color(0xFF6B7280);      // Otros - gris

  /// Obtener color por categoría
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'comida':
      case 'restaurante':
        return categoryFood;
      case 'transport':
      case 'transporte':
      case 'uber':
      case 'taxi':
        return categoryTransport;
      case 'shopping':
      case 'compras':
        return categoryShopping;
      case 'bills':
      case 'facturas':
      case 'servicios':
        return categoryBills;
      case 'health':
      case 'salud':
      case 'farmacia':
        return categoryHealth;
      case 'entertainment':
      case 'entretenimiento':
        return categoryEntertainment;
      case 'travel':
      case 'viaje':
      case 'hotel':
        return categoryTravel;
      default:
        return categoryOther;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface2, surface1],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B0D0F),
      Color(0xFF0D1117),
    ],
  );
}
