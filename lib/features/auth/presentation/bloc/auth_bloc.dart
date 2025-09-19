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

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.getCachedUser,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
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
      (failure) {
        if (failure is AuthFailure) {
          emit(AuthError(message: failure.message));
        } else if (failure is NetworkFailure) {
          emit(AuthError(message: failure.message));
        } else {
          emit(const AuthError(message: 'Login failed'));
        }
      },
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrVoid = await logoutUser(NoParams());
    failureOrVoid.fold(
      (failure) => emit(const AuthError(message: 'Logout failed')),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}