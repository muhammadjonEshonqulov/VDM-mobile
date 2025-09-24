part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}

class UsersActionLoading extends UsersState {
  final List<User> users;
  final int actionUserId;

  const UsersActionLoading({required this.users, required this.actionUserId});

  @override
  List<Object> get props => [users, actionUserId];
}

class UsersActionError extends UsersState {
  final List<User> users;
  final String message;

  const UsersActionError({required this.users, required this.message});

  @override
  List<Object> get props => [users, message];
}
