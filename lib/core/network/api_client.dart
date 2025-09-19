import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/core/constants/app_constants.dart';

import '../utils/app_utils.dart';

class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;

  ApiClient(this._dio, this._sharedPreferences) {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout);
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _sharedPreferences.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          kPrint('🚀 API Request: ${options.method} ${options.baseUrl}${options.path}');
          if (options.data != null) {
            kPrint('📤 Request Data: ${options.data}');
          }
          if (options.headers.isNotEmpty) {
            kPrint('📋 Request Headers: ${options.headers}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          kPrint('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          kPrint('📥 Response Data: ${response.data}');

          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          kPrint('❌ API Error: ${error.message}');
          kPrint('🔍 Error Details: ${error.response?.data}');
          kPrint('📍 Request URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');

          // Handle token expiration or other auth errors
          if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
            kPrint('🔐 Token expired or unauthorized, clearing auth data');
            await _sharedPreferences.remove(AppConstants.tokenKey);
            await _sharedPreferences.remove(AppConstants.userKey);
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
