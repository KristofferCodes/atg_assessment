import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _storage;

  const AuthLocalDatasourceImpl(this._storage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: AppConstants.tokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to save token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to read token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to clear token');
    }
  }
}