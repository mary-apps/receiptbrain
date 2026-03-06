# ReceiptBrain 🧾 — Architecture

**Lines:** 4,534 | **Tier:** Local-First (Hive + Camera)

## Stack
- Flutter + Riverpod + GoRouter
- Hive (local persistence)
- camera + image_picker (receipt scanning)
- fl_chart (expense dashboard)
- flutter_animate + shimmer (UI)
- lucide_icons (iconography)

## Structure
```
lib/
├── core/
│   ├── constants/       # App config
│   ├── router/          # GoRouter
│   ├── services/        # RevenueCat
│   ├── theme/           # Design system
│   └── utils/           # Helpers
├── features/
│   ├── dashboard/       # Expense overview + charts
│   │   ├── model/ provider/ view/ widget/
│   ├── expenses/        # Expense list + CRUD
│   │   ├── model/ provider/ view/ widget/
│   ├── scanner/         # Camera receipt capture + OCR
│   │   ├── model/ provider/ view/ widget/
│   └── settings/        # App settings
│       ├── model/ provider/ widget/
├── shared/
│   └── widgets/         # Reusable components
```

## Key Patterns
- Camera capture → OCR processing → expense entry
- Category-based expense tracking
- Dashboard with fl_chart visualizations
- Offline-first: all data in Hive
- Shimmer loading states during OCR
