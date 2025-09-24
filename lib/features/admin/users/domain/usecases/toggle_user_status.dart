import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/admin/users/domain/repositories/users_repository.dart';

class ToggleUserStatus implements UseCase<void, ToggleUserStatusParams> {
  final UsersRepository repository;

  ToggleUserStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleUserStatusParams params) async {
    return await repository.toggleUserStatus(params.userId);
  }
}

class ToggleUserStatusParams extends Equatable {
  final int userId;

  const ToggleUserStatusParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
