import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/auth/domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetCachedUser getCachedUser;
  final RefreshAuthToken refreshAuthToken;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.getCachedUser,
    required this.refreshAuthToken,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RefreshTokenRequested>(_onRefreshTokenRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final failureOrUser = await getCachedUser(NoParams());
    failureOrUser.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await loginUser(LoginParams(
      username: event.username,
      password: event.password,
    ));
    failureOrUser.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure, 'Login failed'))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrVoid = await logoutUser(NoParams());
    failureOrVoid.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure, 'Logout failed'))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onRefreshTokenRequested(RefreshTokenRequested event, Emitter<AuthState> emit) async {
    final failureOrVoid = await refreshAuthToken(NoParams());
    failureOrVoid.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure, 'Token refresh failed'))),
      (_) => emit(AuthTokenRefreshed()),
    );
  }

  /// Extract error message from failure with fallback to default message
  String _getErrorMessage(Failure failure, String defaultMessage) {
    return failure.message.isNotEmpty ? failure.message : defaultMessage;
  }
}