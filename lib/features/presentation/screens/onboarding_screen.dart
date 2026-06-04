import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../onboarding/controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_widget.dart';

class _OnboardingData {
  final String title;
  final String body;
  final String imagePath;

  const _OnboardingData({
    required this.title,
    required this.body,
    required this.imagePath,
  });
}

const _pages = [
  _OnboardingData(
    title: AppStrings.onboarding1Title,
    body: AppStrings.onboarding1Body,
    imagePath: 'assets/images/onboard_1.png',
  ),
  _OnboardingData(
    title: AppStrings.onboarding2Title,
    body: AppStrings.onboarding2Body,
    imagePath: 'assets/images/onboard_2.png',
  ),
  _OnboardingData(
    title: AppStrings.onboarding3Title,
    body: AppStrings.onboarding3Body,
    imagePath: 'assets/images/onboard_3.png',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final current = ref.read(onboardingControllerProvider);
    if (current < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _previous() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.login);
  }

  Future<void> _skip() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final currentPage = ref.watch(onboardingControllerProvider);
    final isFirst = currentPage == 0;
    final isLast = currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Page content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) =>
                ref.read(onboardingControllerProvider.notifier).goTo(i),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                title: _pages[index].title,
                body: _pages[index].body,
                imagePath: _pages[index].imagePath,
                pageController: _pageController,
                pageCount: _pages.length,
              );
            },
          ),

          // Skip — top right, only on non-last pages
          if (!isLast)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: GestureDetector(
                onTap: _skip,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    AppStrings.skip,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Bottom navigation row
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 28,
            left: 28,
            right: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT — back button, only visible when not first page
                if (!isFirst)
                  GestureDetector(
                    onTap: _previous,
                    behavior: HitTestBehavior.opaque,
                    child: Image.asset(
                      'assets/images/back.png',
                      width: 54,
                      height: 54,
                      errorBuilder: (_, __, ___) => Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                // Spacer pushes next button to the far right always
                const Spacer(),

                // RIGHT — next arrow (pages 1 & 2) or Get Started (last page)
                if (!isLast)
                  GestureDetector(
                    onTap: _next,
                    behavior: HitTestBehavior.opaque,
                    child: Image.asset(
                      'assets/images/next.png',
                      width: 54,
                      height: 54,
                      errorBuilder: (_, __, ___) => Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                if (isLast)
                  GestureDetector(
                    onTap: _finish,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.getStarted,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'assets/images/arrow.png',
                            width: 24,
                            height: 24,
                            //color: Colors.white,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}