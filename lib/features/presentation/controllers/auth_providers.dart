import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../auth/data/datasource/auth_local_datasource.dart';
import '../../auth/data/datasource/auth_remote_datasource.dart';
import '../../auth/data/repositories/auth_repository_impl.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../auth/domain/usecases/login_usecase.dart';
import 'login_controller.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return DioClient(storage);
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDatasourceImpl(dioClient.dio);
});

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return AuthLocalDatasourceImpl(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDatasourceProvider),
    ref.watch(authLocalDatasourceProvider),
  );
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
});

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref.watch(loginUsecaseProvider));
});