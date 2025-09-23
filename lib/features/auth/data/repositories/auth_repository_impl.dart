import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/errors/error_handler.dart';
import 'package:vdm/core/network/network_info.dart';
import 'package:vdm/features/auth/data/datasources/auth_datasource.dart';
import 'package:vdm/features/auth/data/models/auth_models.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final loginRequest = LoginRequest(username: username, password: password);
        final loginResponse = await remoteDataSource.login(loginRequest);
        await localDataSource.cacheToken(loginResponse.token);
        if (loginResponse.refreshToken.isNotEmpty) {
          await localDataSource.cacheRefreshToken(loginResponse.refreshToken);
        }
        await localDataSource.cacheUser(loginResponse.user);
        return Right(loginResponse.user);
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

  @override
  Future<Either<Failure, void>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final refreshToken = await localDataSource.getRefreshToken();
        if (refreshToken == null) {
          return Left(CacheFailure(message: 'No refresh token found'));
        }

        final refreshRequest = RefreshTokenRequest(refreshToken: refreshToken);
        final refreshResponse = await remoteDataSource.refreshToken(refreshRequest);
        
        await localDataSource.cacheToken(refreshResponse.token);
        if (refreshResponse.refreshToken.isNotEmpty) {
          await localDataSource.cacheRefreshToken(refreshResponse.refreshToken);
        }
        
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
  Future<Either<Failure, String>> getRefreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null) {
        return Right(refreshToken);
      } else {
        return Left(CacheFailure(message: 'No refresh token found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
