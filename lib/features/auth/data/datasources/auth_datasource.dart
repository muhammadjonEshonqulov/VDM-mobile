import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/core/utils/app_utils.dart';
import 'package:vdm/features/auth/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);
}

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearAuthData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      AppConstants.loginEndpoint,
      data: request.toJson(),
    );
    
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    final response = await _dio.post(
      AppConstants.refreshTokenEndpoint,
      data: request.toJson(),
    );
    
    return RefreshTokenResponse.fromJson(response.data);
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
  Future<void> cacheRefreshToken(String refreshToken) async {
    await _sharedPreferences.setString(AppConstants.refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _sharedPreferences.getString(AppConstants.refreshTokenKey);
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
    await _sharedPreferences.remove(AppConstants.refreshTokenKey);
    await _sharedPreferences.remove(AppConstants.userKey);
  }
}