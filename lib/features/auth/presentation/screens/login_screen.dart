import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgeta/app_text_field.dart';
import '../../../presentation/controllers/auth_providers.dart';
import '../../../presentation/controllers/login_controller.dart';
import '../widgets/login_error_banner.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late AnimationController _entryController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return AppStrings.emailInvalid;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < 6) return AppStrings.passwordMinLength;
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref.read(loginControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subtextColor = isDark ? AppColors.darkSubtext : AppColors.lightSubtext;

    ref.listen<LoginState>(loginControllerProvider, (prev, next) {
      if (next.isSuccess) {
        context.go(AppRoutes.home);
      }
    });

    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Close / back icon
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.onboarding),
                      child: Icon(Icons.close, color: textColor, size: 24),
                    ),

                    const SizedBox(height: 36),

                    Text(
                      AppStrings.loginTitle,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: textColor,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Error banner
                    if (loginState.isFailure && loginState.errorMessage != null)
                      LoginErrorBanner(message: loginState.errorMessage!),

                    const SizedBox(height: 8),

                    // Email
                    AppTextField(
                      label: AppStrings.emailLabel,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      validator: _validateEmail,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                    ),

                    const SizedBox(height: 28),

                    // Password
                    AppTextField(
                      label: AppStrings.passwordLabel,
                      controller: _passwordController,
                      obscureText: true,
                      showPasswordToggle: true,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocus,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: navigate to forgot password screen
                        },
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Login button — note the elegant color change based on filled state
                    _AnimatedLoginButton(
                      isLoading: loginState.isLoading,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onPressed: loginState.isLoading ? null : _submit,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLoginButton extends StatefulWidget {
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onPressed;

  const _AnimatedLoginButton({
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.onPressed,
  });

  @override
  State<_AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<_AnimatedLoginButton> {
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_updateState);
    widget.passwordController.addListener(_updateState);
  }

  void _updateState() {
    final hasContent = widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty;
    if (hasContent != _hasContent) {
      setState(() => _hasContent = hasContent);
    }
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_updateState);
    widget.passwordController.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: _hasContent
            ? AppColors.primary
            : AppColors.accent.withOpacity(0.55),
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                AppStrings.loginButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}