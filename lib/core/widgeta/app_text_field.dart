import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final bool showPasswordToggle;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.showPasswordToggle = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    widget.focusNode?.addListener(() {
      setState(() => _isFocused = widget.focusNode!.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subtextColor = isDark ? AppColors.darkSubtext : AppColors.lightSubtext;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.bodySmall.copyWith(
            color: _isFocused ? textColor : subtextColor,
            fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Text(widget.label),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.showPasswordToggle ? _obscure : widget.obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: AppTextStyles.bodyLarge.copyWith(color: textColor),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? AppColors.darkHint : AppColors.lightHint,
            ),
            suffixIcon: widget.showPasswordToggle
                ? GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: subtextColor,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}