import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vdm/core/errors/error_handler.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/network/network_info.dart';
import 'package:vdm/features/admin/drivers/data/datasources/drivers_datasource.dart';
import 'package:vdm/features/admin/drivers/data/models/drivers_response.dart';
import 'package:vdm/features/admin/drivers/domain/repositories/drivers_repository.dart';

class DriverRepositoryImpl implements DriversRepository {
  final DriversDatasource datasource;
  final NetworkInfo networkInfo;

  DriverRepositoryImpl({required this.datasource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Driver>>> getDrivers() async {
    if (await networkInfo.isConnected) {
      try {
        final driversResponse = await datasource.getDrivers();
        return Right(driversResponse.data ?? []);
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
