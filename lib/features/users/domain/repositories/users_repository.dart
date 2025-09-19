import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, void>> toggleUserStatus(int userId);
  Future<Either<Failure, void>> deleteUser(int userId);
}
