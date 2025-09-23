import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/auth/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

class GetCachedUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCachedUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}

class GetAuthToken implements UseCase<String, NoParams> {
  final AuthRepository repository;

  GetAuthToken(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getToken();
  }
}

class RefreshAuthToken implements UseCase<void, NoParams> {
  final AuthRepository repository;

  RefreshAuthToken(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.refreshToken();
  }
}

class GetRefreshToken implements UseCase<String, NoParams> {
  final AuthRepository repository;

  GetRefreshToken(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getRefreshToken();
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
