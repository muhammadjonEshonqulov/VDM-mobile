import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => properties.map((e) => e as Object).toList();
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message}) : super([message]);
}

class CacheFailure extends Failure {
  final String message;
  CacheFailure({required this.message}) : super([message]);
}

class NetworkFailure extends Failure {
  final String message;
  NetworkFailure({required this.message}) : super([message]);
}

class AuthFailure extends Failure {
  final String message;
  AuthFailure({required this.message}) : super([message]);
}