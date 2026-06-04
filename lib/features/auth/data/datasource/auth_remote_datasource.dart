import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;

  const AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to extract token — adapt to actual API response shape
        final token = data['token'] ??
            data['access_token'] ??
            data['data']?['token'] ??
            data['data']?['access_token'] ?? '';

        final user = data['user'] ?? data['data']?['user'] ?? data['data'] ?? {};

        return UserModel(
          id: user['id']?.toString() ?? '',
          email: user['email']?.toString() ?? email,
          name: user['name']?.toString() ?? '',
          token: token?.toString() ?? '',
        );
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        throw UnauthorizedException(
          data['message'] ?? 'Invalid credentials',
        );
      } else {
        throw ServerException(
          data['message'] ?? 'An error occurred',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 422) {
        throw UnauthorizedException(
          e.response?.data?['message'] ?? 'Invalid credentials',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection. Please try again.');
      }
      throw ServerException(
        e.response?.data?['message'] ?? 'Something went wrong',
        statusCode: e.response?.statusCode,
      );
    }
  }
}