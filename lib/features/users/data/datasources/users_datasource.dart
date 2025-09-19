import 'package:dio/dio.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/features/users/data/models/users_response.dart';

import '../../../../core/utils/app_utils.dart';

abstract class UsersRemoteDataSource {
  Future<UsersResponse> getUsers();

  Future<void> toggleUserStatus(int userId);

  Future<void> deleteUser(int userId);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final Dio _dio;

  UsersRemoteDataSourceImpl(this._dio);

  @override
  Future<UsersResponse> getUsers() async {
    try {
      final response = await _dio.get(AppConstants.usersEndpoint);
      return UsersResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw DioException(requestOptions: e.requestOptions, error: 'Unauthorized access', type: DioExceptionType.badResponse);
      }
      rethrow;
    }
  }

  @override
  Future<void> toggleUserStatus(int userId) async {
    try {
      kPrint('🔄 Toggling status for user ID: $userId');

      final response = await _dio.patch(AppConstants.userToggleStatusEndpoint(userId));

      kPrint('✅ User status toggled successfully: ${response.data}');
    } on DioException catch (e) {
      kPrint('❌ Failed to toggle user status: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw DioException(requestOptions: e.requestOptions, error: 'Unauthorized access', type: DioExceptionType.badResponse);
      } else if (e.response?.statusCode == 404) {
        throw DioException(requestOptions: e.requestOptions, error: 'User not found', type: DioExceptionType.badResponse);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      kPrint('🗑️ Deleting user ID: $userId');

      final response = await _dio.delete(AppConstants.userDeleteEndpoint(userId));

      kPrint('✅ User deleted successfully: ${response.data}');
    } on DioException catch (e) {
      kPrint('❌ Failed to delete user: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw DioException(requestOptions: e.requestOptions, error: 'Unauthorized access', type: DioExceptionType.badResponse);
      } else if (e.response?.statusCode == 404) {
        throw DioException(requestOptions: e.requestOptions, error: 'User not found', type: DioExceptionType.badResponse);
      } else if (e.response?.statusCode == 403) {
        throw DioException(requestOptions: e.requestOptions, error: 'Cannot delete this user', type: DioExceptionType.badResponse);
      }
      rethrow;
    }
  }
}
