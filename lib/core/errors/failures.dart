import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;
  const Failure([this.properties = const <dynamic>[]]);

  // Abstract getter for message - all failure types must implement this
  String get message;

  @override
  List<Object> get props => properties.map((e) => e as Object).toList();
}

class ServerFailure extends Failure {
  final String _message;
  ServerFailure({required String message}) : _message = message, super([message]);
  
  @override
  String get message => _message;
}

class CacheFailure extends Failure {
  final String _message;
  CacheFailure({required String message}) : _message = message, super([message]);
  
  @override
  String get message => _message;
}

class NetworkFailure extends Failure {
  final String _message;
  NetworkFailure({required String message}) : _message = message, super([message]);
  
  @override
  String get message => _message;
}

class AuthFailure extends Failure {
  final String _message;
  AuthFailure({required String message}) : _message = message, super([message]);
  
  @override
  String get message => _message;
}