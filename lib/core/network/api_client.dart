import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/core/router/app_router.dart';
import 'package:vdm/features/auth/data/models/auth_models.dart';

import '../utils/app_utils.dart';

class ApiClient {
  final GlobalKey<NavigatorState> navigatorKey;

  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  bool _isRefreshing = false;
  final List<({RequestOptions requestOptions, ErrorInterceptorHandler handler})> _requestsQueue = [];

  ApiClient(this._dio, this._sharedPreferences, {required this.navigatorKey}) {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout);
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';

    _setupLogging();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _sharedPreferences.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 && error.requestOptions.path != '/auth/refresh') {
            print('error.requestOptions.path => ${error.requestOptions.path} $_isRefreshing');

            if (_isRefreshing) {
              _addToQueue(error.requestOptions, handler);
              return;
            }

            _isRefreshing = true;

            try {
              final refreshToken = _sharedPreferences.getString(AppConstants.refreshTokenKey);
              if (refreshToken != null) {
                final refreshRequest = RefreshTokenRequest(refreshToken: refreshToken);
                final response = await _dio.post(AppConstants.refreshTokenEndpoint, data: refreshRequest.toJson());

                if (response.statusCode == 200) {
                  final refreshResponse = RefreshTokenResponse.fromJson(response.data);

                  await _sharedPreferences.setString(AppConstants.tokenKey, refreshResponse.token);
                  if (refreshResponse.refreshToken.isNotEmpty) {
                    await _sharedPreferences.setString(AppConstants.refreshTokenKey, refreshResponse.refreshToken);
                  }

                  error.requestOptions.headers['Authorization'] = 'Bearer ${refreshResponse.token}';

                  final retryResponse = await _dio.fetch(error.requestOptions);
                  handler.resolve(retryResponse);

                  _processQueue();
                  return;
                }
              }
            } catch (e) {
              await _clearAuth();
              _rejectAllRequests(error);

              final errorMessage = error.response?.data?['message']?.toString() ?? 'Session expired. Please login again.';

              if (navigatorKey.currentContext != null && navigatorKey.currentContext!.mounted) {
                AppUtils.showErrorSnackBar(navigatorKey.currentContext!, errorMessage);
                // GoRouter.of(navigatorKey.currentContext!).go(AppConstants.routeLogin);
                AppRouter.router.go(AppConstants.routeLogin);
              }

              return handler.next(error);
            } finally {
              _isRefreshing = false;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  void _addToQueue(RequestOptions requestOptions, ErrorInterceptorHandler handler) {
    _requestsQueue.add((requestOptions: requestOptions, handler: handler));
  }

  void _processQueue() async {
    while (_requestsQueue.isNotEmpty) {
      final item = _requestsQueue.removeAt(0);
      try {
        final response = await _dio.fetch(item.requestOptions);
        item.handler.resolve(response);
      } catch (e) {
        item.handler.next(e as DioException);
      }
    }
  }

  void _rejectAllRequests(DioException error) {
    for (var item in _requestsQueue) {
      item.handler.next(error);
    }
    _requestsQueue.clear();
  }

  Future<void> _clearAuth() async {
    await _sharedPreferences.remove(AppConstants.tokenKey);
    await _sharedPreferences.remove(AppConstants.refreshTokenKey);
    await _sharedPreferences.remove(AppConstants.userKey);
  }

  void _setupLogging() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          // requestHeader: true,
          responseBody: true,
          // responseHeader: false,
          error: true,
          logPrint: (object) {
            final cleanLog = object.toString().replaceAll('\n', ' ').trim();
            if (cleanLog.isNotEmpty) {
              kPrint('🌐 API: $cleanLog');
            }
          },
        ),
      );
    }
  }

  Dio get dio => _dio;
}
