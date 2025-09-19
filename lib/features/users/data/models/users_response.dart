import 'package:vdm/features/auth/data/models/auth_models.dart';

class UsersResponse {
  final bool success;
  final String message;
  final List<UserModel> data;
  final int timestamp;

  UsersResponse({required this.success, required this.message, required this.data, required this.timestamp});

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)?.map((user) => UserModel.fromJson(user as Map<String, dynamic>)).toList() ?? [],
      timestamp: json['timestamp'] ?? 0,
    );
  }
}
