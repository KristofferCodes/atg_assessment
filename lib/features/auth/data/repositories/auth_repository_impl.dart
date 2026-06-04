import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;

  const AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remote.login(email: email, password: password);
      if (model.token != null && model.token!.isNotEmpty) {
        await _local.saveToken(model.token!);
      }
      return Right(model.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _local.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getStoredToken() async {
    try {
      final token = await _local.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}