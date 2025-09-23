import 'package:dio/dio.dart';
import 'package:vdm/features/drivers/data/models/drivers_response.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/error_handler.dart';

abstract class DriversDatasource {
  Future<DriversResponse> getDrivers();
}

class DriversDatasourceImpl implements DriversDatasource {
  final Dio _dio;

  DriversDatasourceImpl(this._dio);

  @override
  Future<DriversResponse> getDrivers() async {
    try {
      var response = await _dio.get(AppConstants.driversEndpoint);
      return DriversResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
