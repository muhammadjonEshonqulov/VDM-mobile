import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vdm/core/errors/error_handler.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/network/network_info.dart';
import 'package:vdm/features/drivers/data/datasources/drivers_datasource.dart';
import 'package:vdm/features/drivers/data/models/Driver.dart';
import 'package:vdm/features/drivers/domain/repositories/drivers_repository.dart';

class DriverRepositoryImpl implements DriversRepository {
  final DriversDatasource _datasource;
  final NetworkInfo _networkInfo;

  DriverRepositoryImpl(this._datasource, this._networkInfo);

  @override
  Future<Either<Failure, List<Driver>>> getDrivers() async {
    if (await _networkInfo.isConnected) {
      try {
        final driversResponse = await _datasource.getDrivers();
        return Right(driversResponse);
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
