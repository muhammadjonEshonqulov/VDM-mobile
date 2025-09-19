import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/features/auth/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
}

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearAuthData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: request.toJson(),
      );
      
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          error: 'Invalid credentials',
          type: DioExceptionType.badResponse,
        );
      }
      rethrow;
    }
  }
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> cacheToken(String token) async {
    await _sharedPreferences.setString(AppConstants.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _sharedPreferences.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = _sharedPreferences.getString(AppConstants.userKey);
    
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        // If parsing fails, clear the invalid data
        await _sharedPreferences.remove(AppConstants.userKey);
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearAuthData() async {
    await _sharedPreferences.remove(AppConstants.tokenKey);
    await _sharedPreferences.remove(AppConstants.userKey);
  }
}