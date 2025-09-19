import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/users/domain/repositories/users_repository.dart';

class GetUsers implements UseCase<List<User>, NoParams> {
  final UsersRepository repository;

  GetUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUsers();
  }
}
