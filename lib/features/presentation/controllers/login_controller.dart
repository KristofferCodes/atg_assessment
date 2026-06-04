import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../auth/domain/usecases/login_usecase.dart';
enum LoginStatus { idle, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.idle,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
}

class LoginController extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;

  LoginController(this._loginUsecase) : super(const LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    final result = await _loginUsecase(
      LoginParams(email: email.trim(), password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: LoginStatus.success,
        user: user,
      ),
    );
  }

  void resetState() {
    state = const LoginState();
  }
}