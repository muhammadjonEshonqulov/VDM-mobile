import 'package:dartz/dartz.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/drivers/data/models/Driver.dart';
import 'package:vdm/features/drivers/domain/repositories/drivers_repository.dart';

class GetDrivers implements UseCase<List<Driver>, NoParams> {
  final DriversRepository repository;

  GetDrivers(this.repository);

  @override
  Future<Either<Failure, List<Driver>>> call(NoParams params) {
    return repository.getDrivers();
  }
}
