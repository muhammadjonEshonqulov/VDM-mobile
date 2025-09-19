import 'package:equatable/equatable.dart';

enum UserRole {
  ADMIN,
  MANAGER,
  OPERATOR,
  UNKNOWN,
}

class User extends Equatable {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, username, fullName, email, phone, role, active, createdAt, updatedAt];
}