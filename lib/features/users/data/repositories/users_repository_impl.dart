import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/errors/error_handler.dart';
import 'package:vdm/core/network/network_info.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/users/data/datasources/users_datasource.dart';
import 'package:vdm/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UsersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final usersResponse = await remoteDataSource.getUsers();
        return Right(usersResponse.data);
      } on DioException catch (e) {
        return Left(ErrorHandler.handleDioError(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleUserStatus(int userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.toggleUserStatus(userId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(ErrorHandler.handleDioError(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(userId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(ErrorHandler.handleDioError(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
