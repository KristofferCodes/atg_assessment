import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final Widget? icon;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null || isLoading;

    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = backgroundColor ?? AppColors.primary;
        fgColor = Colors.white;
      case ButtonVariant.secondary:
        bgColor = backgroundColor ?? AppColors.accent;
        fgColor = Colors.white;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = isDark ? AppColors.darkText : AppColors.lightText;
        border = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        );
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
    }

    if (isDisabled && variant == ButtonVariant.primary) {
      bgColor = AppColors.accent.withOpacity(0.6);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: border ?? BorderSide.none,
          ),
          elevation: 0,
          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: fgColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: AppTextStyles.labelLarge),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    icon!,
                  ],
                ],
              ),
      ),
    );
  }
}