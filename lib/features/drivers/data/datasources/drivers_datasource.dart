import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/error_handler.dart';
import '../models/Driver.dart';

abstract class DriversDatasource {
  Future<List<Driver>> getDrivers();
}

class DriversDatasourceImpl implements DriversDatasource {
  final Dio _dio;

  DriversDatasourceImpl(this._dio);

  @override
  Future<List<Driver>> getDrivers() async {
    try {
      var response = await _dio.get(AppConstants.driversEndpoint);
      return response.data.map((e) => Driver.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
