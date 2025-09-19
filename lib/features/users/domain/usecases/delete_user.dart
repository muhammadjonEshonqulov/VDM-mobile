import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/users/domain/repositories/users_repository.dart';

class DeleteUser implements UseCase<void, DeleteUserParams> {
  final UsersRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await repository.deleteUser(params.userId);
  }
}

class DeleteUserParams extends Equatable {
  final int userId;

  const DeleteUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
