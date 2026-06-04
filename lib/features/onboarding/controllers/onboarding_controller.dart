import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, int>((ref) {
  return OnboardingController();
});

class OnboardingController extends StateNotifier<int> {
  OnboardingController() : super(0);

  void next(int total) {
    if (state < total - 1) state++;
  }

  void previous() {
    if (state > 0) state--;
  }

  void goTo(int index) => state = index;

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingKey, true);
  }
}