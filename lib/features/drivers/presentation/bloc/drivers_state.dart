part of 'drivers_bloc.dart';

abstract class DriversState extends Equatable {
  const DriversState();

  @override
  List<Object?> get props => [];
}

class DriversInitial extends DriversState {}

class DriversLoading extends DriversState {}
class DriversError extends DriversState {
  final String message;

  const DriversError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DriversLoaded extends DriversState {
  final List<Driver> drivers;

  const DriversLoaded({required this.drivers});

  @override
  List<Object?> get props => [drivers];
}
