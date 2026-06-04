class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://atg.smartrobtech.com';
  static const String loginEndpoint = '/api/auth/login';

  static const String tokenKey = 'auth_token';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_done';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 250);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 500);
}