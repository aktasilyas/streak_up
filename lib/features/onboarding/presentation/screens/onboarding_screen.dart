import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_up/core/constants/app_dimensions.dart';
import 'package:streak_up/core/constants/app_strings.dart';
import 'package:streak_up/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:streak_up/router/app_router.dart';

/// Onboarding ekranı
///
/// İlk kullanıcılar için 3 sayfalık tanıtım.
/// PageView ile kaydırılabilir sayfalar.
/// Son sayfada "Başla" butonu ile ana ekrana geçiş.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// SharedPreferences key — onboarding tamamlanma durumu
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım — Geç butonu
            _buildTopBar(context),

            // PageView — onboarding sayfaları
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingPage(
                    icon: Icons.check_circle_outline,
                    title: AppStrings.onboardingPage1Title,
                    description: AppStrings.onboardingPage1Subtitle,
                    color: colorScheme.primary,
                  ),
                  OnboardingPage(
                    icon: Icons.local_fire_department,
                    title: AppStrings.onboardingPage2Title,
                    description: AppStrings.onboardingPage2Subtitle,
                    color: colorScheme.secondary,
                  ),
                  OnboardingPage(
                    icon: Icons.insights,
                    title: AppStrings.onboardingPage3Title,
                    description: AppStrings.onboardingPage3Subtitle,
                    color: colorScheme.tertiary,
                  ),
                ],
              ),
            ),

            // Alt kısım — Dot indicator + buton
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  /// Üst bar — Geç butonu (son sayfa hariç)
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentPage < 2)
            TextButton(
              onPressed: _completeOnboarding,
              child: const Text(AppStrings.onboardingSkip),
            ),
        ],
      ),
    );
  }

  /// Alt bölüm — Dot indicator + İleri/Başla butonu
  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot indicator
          _buildPageIndicator(),

          const SizedBox(height: AppDimensions.paddingL),

          // İleri / Başla butonu
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _currentPage < 2 ? _nextPage : _completeOnboarding,
              child: Text(
                _currentPage < 2
                    ? AppStrings.onboardingNext
                    : AppStrings.onboardingGetStarted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sayfa gösterge noktaları
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: AppDimensions.animationDurationMs),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXs),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
    );
  }

  /// Sonraki sayfaya geç
  void _nextPage() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: AppDimensions.animationDurationMs),
      curve: Curves.easeInOut,
    );
  }

  /// Onboarding'i tamamla ve ana ekrana geç
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);

    if (mounted) {
      context.go(AppRoutes.habits);
    }
  }
}
