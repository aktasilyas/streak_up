# StreakUp — Alışkanlık Takip Uygulaması

## Proje Özeti
Günlük alışkanlıkları takip eden, streak sistemiyle motivasyon sağlayan, AdMob reklamlarla gelir üreten Flutter uygulaması.

---

## Mimari Kurallar (ZORUNLU)

### Clean Architecture
```
lib/
├── core/                          # Paylaşılan altyapı
│   ├── constants/                 # Renkler, stringler, boyutlar
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_dimensions.dart
│   ├── extensions/                # Dart extension'ları
│   │   ├── context_extensions.dart
│   │   ├── date_extensions.dart
│   │   └── string_extensions.dart
│   ├── theme/                     # Material 3 tema
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/                     # Yardımcı fonksiyonlar
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   └── widgets/                   # Ortak widget'lar
│       ├── app_scaffold.dart
│       ├── responsive_builder.dart
│       └── loading_widget.dart
├── features/
│   ├── habits/                    # Ana özellik
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── habit_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── habit_model.dart
│   │   │   │   └── habit_model.g.dart
│   │   │   └── repositories/
│   │   │       └── habit_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── habit.dart
│   │   │   ├── repositories/
│   │   │   │   └── habit_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_habit.dart
│   │   │       ├── delete_habit.dart
│   │   │       ├── get_habits.dart
│   │   │       ├── toggle_habit_completion.dart
│   │   │       └── get_habit_stats.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── habit_list_provider.dart
│   │       │   └── habit_form_provider.dart
│   │       ├── screens/
│   │       │   ├── habit_list_screen.dart
│   │       │   └── habit_form_screen.dart
│   │       └── widgets/
│   │           ├── habit_card.dart
│   │           ├── streak_badge.dart
│   │           └── habit_check_button.dart
│   ├── statistics/                # İstatistik özelliği
│   │   ├── data/...
│   │   ├── domain/...
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── stats_provider.dart
│   │       ├── screens/
│   │       │   └── stats_screen.dart
│   │       └── widgets/
│   │           ├── calendar_heatmap.dart
│   │           ├── streak_chart.dart
│   │           └── weekly_summary_card.dart
│   ├── settings/                  # Ayarlar
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │           └── theme_selector.dart
│   └── onboarding/                # İlk açılış
│       └── presentation/
│           └── screens/
│               └── onboarding_screen.dart
├── services/
│   ├── ad_service.dart            # AdMob wrapper (Singleton)
│   ├── notification_service.dart  # Local notification wrapper
│   ├── database_service.dart      # SQLite wrapper
│   └── analytics_service.dart     # Firebase analytics wrapper
├── router/
│   └── app_router.dart            # go_router tanımları
└── main.dart
```

### Design Patterns
- **Repository Pattern:** Domain katmanı sadece abstract repository'ye bağımlı
- **Singleton Pattern:** AdService, DatabaseService, NotificationService
- **Strategy Pattern:** Streak hesaplama (günlük/haftalık alışkanlıklar farklı strateji)
- **Observer Pattern:** Riverpod provider'lar ile reaktif state
- **Factory Pattern:** Model → Entity dönüşümlerinde factory constructor

### SOLID Prensipleri
- **S:** Her dosya tek sorumluluk. UseCase = 1 iş. Widget = 1 görsel birim.
- **O:** Yeni alışkanlık tipi eklemek için mevcut kod değişmemeli.
- **L:** HabitRepository implementasyonları birbiri yerine geçebilmeli.
- **I:** Büyük interface'ler küçük parçalara bölünmeli.
- **D:** Presentation → Domain ← Data. Asla tersi. Presentation katmanı Data katmanını import ETMEZ.

---

## Kodlama Kuralları (ZORUNLU)

### Genel
- **Dil:** Dart 3.x, null safety zorunlu
- **Yorum dili:** Türkçe
- **Max dosya uzunluğu:** 300 satır. Aşarsa böl.
- **Max fonksiyon uzunluğu:** 40 satır. Aşarsa extract et.
- **Max parametre sayısı:** 5. Aşarsa nesne ile sar.
- **Const her yerde:** `const` kullanılabilecek her widget'ta kullan.
- **Kod tekrarı yasak:** 2 kez tekrar eden kod → ortak metod/widget.
- **Magic number yasak:** Tüm sabitler `constants/` altında.
- **Print yasak:** Sadece `debugPrint` veya logger kullan.
- **String literal yasak (UI):** Tüm UI stringleri `AppStrings` içinde.

### Naming Conventions
```dart
// Dosya: snake_case
habit_card.dart

// Sınıf: PascalCase
class HabitCard extends StatelessWidget

// Değişken/metod: camelCase
final int currentStreak;
void toggleCompletion() {}

// Sabit: camelCase (top-level veya static)
static const double cardRadius = 12.0;

// Private: _ prefix
final _habitRepository = HabitRepository();

// Provider: camelCase + Provider suffix
final habitListProvider = StateNotifierProvider<...>(...);

// Enum: PascalCase, değerler camelCase
enum HabitFrequency { daily, weekly, custom }
```

### Widget Kuralları
```dart
// ✅ DOĞRU: Stateless tercih et, const constructor kullan
class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  final Habit habit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) { ... }
}

// ❌ YANLIŞ: Gereksiz StatefulWidget
// ❌ YANLIŞ: const olmayan constructor
// ❌ YANLIŞ: Widget içinde iş mantığı
```

### Responsive Tasarım Kuralları
```dart
// HER ekran responsive olmalı. Sabit piksel değeri YASAK.
// core/widgets/responsive_builder.dart kullan:

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints) builder;
  // compact: < 600dp, medium: 600-840dp, expanded: > 840dp
}

// Padding/margin için AppDimensions kullan:
// AppDimensions.paddingS = 8
// AppDimensions.paddingM = 16
// AppDimensions.paddingL = 24

// Font size için TextStyle theme kullan, asla sabit boyut verme:
// Theme.of(context).textTheme.bodyLarge
```

---

## State Management: Riverpod 2.x

### Provider Yapısı
```dart
// 1. UseCase provider (domain)
final createHabitUseCaseProvider = Provider<CreateHabit>((ref) {
  return CreateHabit(ref.watch(habitRepositoryProvider));
});

// 2. Repository provider (data)
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(ref.watch(habitLocalDatasourceProvider));
});

// 3. State provider (presentation)
final habitListProvider = AsyncNotifierProvider<HabitListNotifier, List<Habit>>(() {
  return HabitListNotifier();
});
```

### Kurallar
- Provider'da iş mantığı YASAK → UseCase'e taşı
- AsyncNotifierProvider kullan (FutureProvider değil, state mutation lazım)
- `ref.watch` render'da, `ref.read` callback'lerde
- Family provider: parametreli sorgular için

---

## Veritabanı: SQLite

### Şema
```sql
CREATE TABLE habits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT NOT NULL DEFAULT '✅',
  color INTEGER NOT NULL DEFAULT 0xFF4CAF50,
  frequency TEXT NOT NULL DEFAULT 'daily', -- daily, weekly, custom
  target_days TEXT, -- JSON array: [1,2,3,4,5] (Pazartesi-Cuma)
  reminder_time TEXT, -- "08:00" format
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  is_archived INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE completions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  habit_id INTEGER NOT NULL,
  completed_at TEXT NOT NULL, -- ISO 8601 date only: "2025-02-23"
  note TEXT,
  FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE,
  UNIQUE(habit_id, completed_at)
);

CREATE INDEX idx_completions_habit_date ON completions(habit_id, completed_at);
```

### Migration Kuralı
- Her şema değişikliği version numarası artırılarak `onUpgrade` ile yapılmalı
- Drop table ASLA yapılmaz

---

## Reklam Stratejisi

### Yerleşim
| Ekran | Format | Tetikleyici |
|-------|--------|------------|
| Habit listesi | Banner (alt) | Her zaman |
| Haftalık özet | Interstitial | Özet açıldığında (max 1/saat) |
| Streak kurtarma | Rewarded Video | Kullanıcı "kurtarmak istiyorum" dediğinde |
| İstatistik detay | Interstitial | 3. görüntülemede (frequency cap) |

### Kurallar
- Test sırasında SADECE test ad unit ID kullan
- Interstitial gösterimi arasında min 120 saniye
- Rewarded video sonucu kesinlikle doğrulanmalı (onUserEarnedReward callback)
- Reklam yüklenemezse UI bozulmamalı (graceful degradation)

---

## Tema: Material 3

### Renk Paleti
```dart
// Ana renk: Warm teal/green (alışkanlık = büyüme)
// Seed color: Color(0xFF26A69A)
// ColorScheme.fromSeed kullan, manual renk atama
// Dark theme: aynı seed, brightness: Brightness.dark
```

### Tasarım İlkeleri
- Material 3 component'leri kullan (FilledButton, Card.filled, SearchBar...)
- Border radius: 16 (kartlar), 12 (butonlar), 24 (bottom sheet)
- Elevation yerine tonal elevation tercih et
- Animasyon: 300ms default, hero transitions sayfa geçişlerinde
- Haptic feedback: check/uncheck işlemlerinde

---

## Branch Stratejisi

```
main                    ← Production-ready, sadece merge ile
├── develop             ← Tüm feature'lar buraya merge edilir
│   ├── feature/core-setup          ← Proje yapısı, tema, router
│   ├── feature/database            ← SQLite şema, migration, datasource
│   ├── feature/habit-domain        ← Entity, repository interface, usecases
│   ├── feature/habit-data          ← Model, datasource impl, repository impl
│   ├── feature/habit-presentation  ← Provider, ekranlar, widget'lar
│   ├── feature/statistics          ← İstatistik feature komple
│   ├── feature/notifications       ← Local notification servisi
│   ├── feature/admob               ← Reklam entegrasyonu
│   ├── feature/settings            ← Ayarlar + tema değiştirme
│   ├── feature/onboarding          ← İlk açılış ekranı
│   └── feature/polish              ← Animasyonlar, son düzeltmeler
└── hotfix/*            ← Acil düzeltmeler
```

### Branch Kuralları
- Her feature branch `develop`'dan açılır
- Feature tamamlanınca `develop`'a merge
- Tüm feature'lar merge edildikten sonra `develop` → `main`
- Commit mesajları: `feat:`, `fix:`, `refactor:`, `style:`, `docs:`, `test:`
- Her commit çalışır durumda olmalı (broken commit yasak)

---

## Agent Görev Dağılımı

### Opus 4.6 Agent (Karmaşık İş Mantığı)
- Domain katmanı: entity, repository interface, usecase
- Streak hesaplama algoritması
- Veritabanı şeması ve migration
- AdService, NotificationService tasarımı
- Code review ve refactoring kararları
- Karmaşık provider logic

### Sonnet Agent — UI Builder
- Tüm screen ve widget dosyaları
- Tema ve renk sistemi
- Responsive layout
- Animasyonlar
- Onboarding ekranı

### Sonnet Agent — DevOps & Test
- Firebase / AdMob konfigürasyonu
- Unit test yazımı
- Widget test yazımı
- Store asset hazırlığı (açıklama metinleri)
- CI/CD script'leri

### Agent Çakışma Önleme Kuralları
1. Aynı dosyayı aynı anda iki agent düzenlemesin
2. Opus → domain + data + services klasörleri
3. Sonnet UI → presentation + core/widgets + core/theme
4. Sonnet DevOps → test/ + android/ + ios/ + scripts/
5. Ortak dosya (main.dart, app_router.dart) → sadece Opus düzenler

---

## Performans Kuralları
- `ListView.builder` kullan (asla `ListView(children: [...])`)
- Resimler: `cached_network_image` veya pre-cached asset
- Provider'da gereksiz rebuild önle: `select` kullan
- SQLite sorgularında index kullan
- Release build'de `--obfuscate --split-debug-info` kullan

---

## Yasak Listesi (ASLA YAPMA)
- ❌ `setState` kullanma (Riverpod var)
- ❌ BuildContext'i async gap üzerinden taşıma
- ❌ God class (300+ satır dosya)
- ❌ Hardcoded string/color/dimension
- ❌ Business logic widget içinde
- ❌ `print()` kullanma
- ❌ Force unwrap (`!`) kullanma — null check yap
- ❌ `dynamic` tip kullanma
- ❌ Relative import (`../../../`) — package import kullan
- ❌ Test ad ID'leriyle production build
