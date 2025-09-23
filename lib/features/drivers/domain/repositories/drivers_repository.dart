import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';

import '../../data/models/Driver.dart';

abstract class DriversRepository {
  Future<Either<Failure, List<Driver>>> getDrivers();
}