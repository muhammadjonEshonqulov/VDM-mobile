part of 'drivers_bloc.dart';

abstract class DriversEvent extends Equatable {
  const DriversEvent();

  @override
  List<Object?> get props => [];
}

class LoadDriversEvent extends DriversEvent {
  const LoadDriversEvent();

  @override
  List<Object?> get props => [];
}
