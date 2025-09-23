import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, String>> getToken();
  Future<Either<Failure, void>> refreshToken();
  Future<Either<Failure, String>> getRefreshToken();
}