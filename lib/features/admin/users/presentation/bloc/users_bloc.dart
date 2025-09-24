import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vdm/core/errors/failures.dart';
import 'package:vdm/core/usecases/usecase.dart';
import 'package:vdm/features/admin/users/domain/usecases/delete_user.dart';
import 'package:vdm/features/admin/users/domain/usecases/get_users.dart';
import 'package:vdm/features/admin/users/domain/usecases/toggle_user_status.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;
  final ToggleUserStatus toggleUserStatus;
  final DeleteUser deleteUser;

  UsersBloc({required this.getUsers, required this.toggleUserStatus, required this.deleteUser}) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    final failureOrUsers = await getUsers(NoParams());

    failureOrUsers.fold((failure) => emit(UsersError(message: failure.message)), (users) => emit(UsersLoaded(users: users)));
  }

  Future<void> _onToggleUserStatus(ToggleUserStatusEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    if (currentState is! UsersLoaded) return;

    if (kDebugMode) {
      debugPrint('🔄 Toggling status for user ID: ${event.userId}');
    }

    emit(UsersActionLoading(users: currentState.users, actionUserId: event.userId));

    final failureOrVoid = await toggleUserStatus(ToggleUserStatusParams(userId: event.userId));

    failureOrVoid.fold(
      (failure) {
        String errorMessage = 'Failed to toggle user status';
        if (failure is AuthFailure) {
          errorMessage = failure.message;
        } else if (failure is NetworkFailure) {
          errorMessage = failure.message;
        } else if (failure is ServerFailure) {
          errorMessage = failure.message;
        }

        if (kDebugMode) {
          debugPrint('❌ Failed to toggle user status: $errorMessage');
        }
        emit(UsersActionError(users: currentState.users, message: errorMessage));
        // Return to loaded state after showing error
        Future.delayed(const Duration(seconds: 2), () {
          if (!emit.isDone) {
            emit(UsersLoaded(users: currentState.users));
          }
        });
      },
      (_) {
        if (kDebugMode) {
          debugPrint('✅ User status toggled successfully, reloading users');
        }
        // Reload users to get updated status
        add(const LoadUsers());
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    if (currentState is! UsersLoaded) return;

    if (kDebugMode) {
      debugPrint('🗑️ Deleting user ID: ${event.userId}');
    }

    emit(UsersActionLoading(users: currentState.users, actionUserId: event.userId));

    final failureOrVoid = await deleteUser(DeleteUserParams(userId: event.userId));

    failureOrVoid.fold(
      (failure) {
        String errorMessage = 'Failed to delete user';
        if (failure is AuthFailure) {
          errorMessage = failure.message;
        } else if (failure is NetworkFailure) {
          errorMessage = failure.message;
        } else if (failure is ServerFailure) {
          errorMessage = failure.message;
        }

        if (kDebugMode) {
          debugPrint('❌ Failed to delete user: $errorMessage');
        }
        emit(UsersActionError(users: currentState.users, message: errorMessage));
        // Return to loaded state after showing error
        Future.delayed(const Duration(seconds: 2), () {
          if (!emit.isDone) {
            emit(UsersLoaded(users: currentState.users));
          }
        });
      },
      (_) {
        if (kDebugMode) {
          debugPrint('✅ User deleted successfully, reloading users');
        }
        // Reload users to get updated list
        add(const LoadUsers());
      },
    );
  }
}
