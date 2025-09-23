import 'package:dio/dio.dart';

import 'failures.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    String errorMessage = 'An error occurred';

    switch (error.response?.statusCode) {
      case 400:
        errorMessage = _extractErrorMessage(error, 'Bad request');
        return ServerFailure(message: errorMessage);

      case 401:
        errorMessage = _extractErrorMessage(error, 'Avtorizatsiya talab qilinadi');
        return AuthFailure(message: errorMessage);

      case 403:
        errorMessage = _extractErrorMessage(error, 'Ruxsat berilmagan');
        return AuthFailure(message: errorMessage);

      case 404:
        errorMessage = _extractErrorMessage(error, 'Ma\'lumot topilmadi');
        return ServerFailure(message: errorMessage);

      case 422:
        errorMessage = _extractErrorMessage(error, 'Noto\'g\'ri ma\'lumotlar');
        return ServerFailure(message: errorMessage);

      case 500:
        errorMessage = _extractErrorMessage(error, 'Server xatosi');
        return ServerFailure(message: errorMessage);

      default:
        // Handle network errors

        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            return NetworkFailure(message: 'Internet aloqasi vaqti tugadi');

          case DioExceptionType.connectionError:
            return NetworkFailure(message: 'Internet aloqasi yo\'q');

          default:
            errorMessage = _extractErrorMessage(error, 'Noma\'lum xatolik');
            return ServerFailure(message: errorMessage);
        }
    }
  }

  static String _extractErrorMessage(DioException error, String defaultMessage) {
    try {
      if (error.response?.data != null) {
        final data = error.response!.data;

        if (data is Map<String, dynamic>) {
          // Try different possible error message fields
          return data['message'] ?? data['error'] ?? data['msg'] ?? data['description'] ?? defaultMessage;
        } else if (data is String) {
          return data;
        }
      }
    } catch (e) {
      // If extraction fails, return default message
    }

    return defaultMessage;
  }
}
