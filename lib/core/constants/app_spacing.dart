/// Sistema de espaciado premium — 8pt grid
class AppSpacing {
  AppSpacing._();

  // ═══════════════════════════════════════════════════════════════
  // BASE SPACING (8pt grid)
  // ═══════════════════════════════════════════════════════════════

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;

  // ═══════════════════════════════════════════════════════════════
  // SCREEN PADDING
  // ═══════════════════════════════════════════════════════════════

  /// Padding horizontal de pantalla
  static const double screenPadding = 20;

  /// Padding inferior de scroll (safe area + espacio extra)
  static const double scrollBottom = 120;

  // ═══════════════════════════════════════════════════════════════
  // COMPONENT SIZING
  // ═══════════════════════════════════════════════════════════════

  /// Altura de bottom navigation
  static const double bottomNavHeight = 72;

  /// Altura de botones principales
  static const double buttonHeight = 56;

  /// Altura de inputs
  static const double inputHeight = 52;

  /// Altura de cards pequeñas
  static const double cardHeightSmall = 80;

  /// Altura de cards medianas
  static const double cardHeightMedium = 120;

  /// Altura de cards grandes
  static const double cardHeightLarge = 180;

  // ═══════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 28;
  static const double radiusFull = 999;

  // ═══════════════════════════════════════════════════════════════
  // ICON SIZING
  // ═══════════════════════════════════════════════════════════════

  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconXxl = 48;

  // ═══════════════════════════════════════════════════════════════
  // ANIMATION
  // ═══════════════════════════════════════════════════════════════

  /// Delay entre items en stagger animation
  static const int staggerDelayMs = 60;

  /// Duración de animaciones micro (botones)
  static const int microDurationMs = 150;

  /// Duración de animaciones pequeñas
  static const int smallDurationMs = 300;

  /// Duración de animaciones medianas
  static const int mediumDurationMs = 500;

  /// Duración de animaciones grandes
  static const int largeDurationMs = 800;

  /// Duración de conteo de números
  static const int countDurationMs = 1200;
}
