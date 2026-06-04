import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgeta/app_button.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ThemeSelectionScreen> createState() =>
      _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends ConsumerState<ThemeSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  ThemeMode _selected = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final notifier = ref.read(themeModeProvider.notifier);
    if (_selected == ThemeMode.dark) {
      notifier.setDark();
    } else {
      notifier.setLight();
    }
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    AppStrings.chooseTheme,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pick how youd like the app to look. You can change this later.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkSubtext : AppColors.lightSubtext,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _ThemeCard(
                    label: AppStrings.themeLight,
                    isSelected: _selected == ThemeMode.light,
                    isDarkCard: false,
                    onTap: () => setState(() => _selected = ThemeMode.light),
                  ),
                  const SizedBox(height: 16),
                  _ThemeCard(
                    label: AppStrings.themeDark,
                    isSelected: _selected == ThemeMode.dark,
                    isDarkCard: true,
                    onTap: () => setState(() => _selected = ThemeMode.dark),
                  ),
                  const Spacer(),
                  AppButton(
                    label: AppStrings.themeContinue,
                    onPressed: _confirm,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDarkCard;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.label,
    required this.isSelected,
    required this.isDarkCard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 100,
        decoration: BoxDecoration(
          color: isDarkCard ? const Color(0xFF0D0D0D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                isDarkCard ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDarkCard ? Colors.white70 : AppColors.lightSubtext,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDarkCard ? Colors.white : AppColors.lightText,
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isDarkCard
                            ? Colors.white30
                            : AppColors.lightBorder,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}