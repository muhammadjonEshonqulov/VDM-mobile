import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/network/network_info.dart';
import 'package:vdm/core/utils/app_utils.dart';
import 'package:vdm/features/auth/data/datasources/auth_datasource.dart';
import 'package:vdm/features/auth/data/models/auth_models.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final loginRequest = LoginRequest(username: username, password: password);
        final loginResponse = await remoteDataSource.login(loginRequest);
        await localDataSource.cacheToken(loginResponse.token);
        await localDataSource.cacheUser(loginResponse.user);
        return Right(loginResponse.user);
      } on DioException catch (e) {

        kPrint('Error in login ${e.message} ${e}');
        if (e.response?.statusCode == 401) {
          return Left(AuthFailure(message: 'Invalid credentials'));
        }
        return Left(ServerFailure(message: e.message ?? 'Login faileddd'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      if (userModel != null) {
        return Right(userModel);
      } else {
            return Left(CacheFailure(message: 'No cached user found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        return Right(token);
      } else {
            return Left(CacheFailure(message: 'No token found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}