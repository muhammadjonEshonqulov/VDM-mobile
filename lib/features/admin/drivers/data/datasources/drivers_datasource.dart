import 'package:dio/dio.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/core/errors/error_handler.dart';
import 'package:vdm/features/admin/drivers/data/models/drivers_response.dart';

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
