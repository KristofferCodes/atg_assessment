import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String body;
  final String imagePath;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.body,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image — replace with real asset
        _buildBackground(size),

        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.85),
                  Colors.black,
                ],
                stops: const [0.0, 0.35, 0.55, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Text content
        Positioned(
          bottom: 120,
          left: 28,
          right: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.displayLarge.copyWith(
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(Size size) {
    // When you add actual images, replace with:
    // Image.asset(imagePath, fit: BoxFit.cover, width: size.width, height: size.height)
    return Container(
      width: size.width,
      height: size.height,
      color: const Color(0xFF2C1A1A),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      AppColors.primary.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.image_outlined,
              color: Colors.white24,
              size: 80,
            ),
          ),
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '[ Replace with image: $imagePath ]',
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}