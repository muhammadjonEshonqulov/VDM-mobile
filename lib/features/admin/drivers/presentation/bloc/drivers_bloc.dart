import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/admin/drivers/data/models/drivers_response.dart';
import 'package:vdm/features/admin/drivers/domain/usecases/get_drivers.dart';

part 'drivers_event.dart';
part 'drivers_state.dart';

class DriversBloc extends Bloc<DriversEvent, DriversState> {
  final GetDrivers getDrivers;

  DriversBloc({required this.getDrivers}) : super(DriversInitial()) {
    on<LoadDriversEvent>(_onLoadDrivers);
  }

  Future<void> _onLoadDrivers(LoadDriversEvent event, Emitter<DriversState> emit) async {
    emit(DriversLoading());

    var failureOrDrivers = await getDrivers(NoParams());

    failureOrDrivers.fold((failure) => emit(DriversError(message: failure.message)), (drivers) => emit(DriversLoaded(drivers: drivers)));
  }
}
