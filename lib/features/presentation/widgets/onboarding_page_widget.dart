import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String body;
  final String imagePath;
  final PageController pageController;
  final int pageCount;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.body,
    required this.imagePath,
    required this.pageController,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subtextColor = isDark ? AppColors.darkSubtext : AppColors.lightSubtext;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.62,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Actual image
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFD4C0C0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          color: Colors.white38,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          imagePath.split('/').last,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom-to-white gradient fade
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size.height * 0.18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        bgColor.withOpacity(0.0),
                        bgColor.withOpacity(0.5),
                        bgColor.withOpacity(0.85),
                        bgColor,
                      ],
                      stops: const [0.0, 0.4, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text content 
        Expanded(
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.fromLTRB(28, 4, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: textColor,
                    height: 1.15,
                    fontSize: 32
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: subtextColor,
                    fontSize: 16
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SmoothPageIndicator(
                  controller: pageController,
                  count: pageCount,
                  effect: const WormEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: Color(0xFFD0D0D0),
                    dotHeight: 6,
                    dotWidth: 20,
                    spacing: 6,
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}