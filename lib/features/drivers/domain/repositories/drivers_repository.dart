import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/features/drivers/data/models/drivers_response.dart';

abstract class DriversRepository {
  Future<Either<Failure, List<Driver>>> getDrivers();
}
