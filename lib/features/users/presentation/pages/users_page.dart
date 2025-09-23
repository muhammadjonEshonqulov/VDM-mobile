import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/core/constants/app_constants.dart';
import 'package:vdm/core/utils/app_utils.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/users/presentation/bloc/users_bloc.dart';
import 'package:vdm/features/users/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:vdm/features/users/presentation/widgets/user_card.dart';
import 'package:vdm/features/users/presentation/widgets/users_empty_widget.dart';
import 'package:vdm/features/users/presentation/widgets/users_error_widget.dart';
import 'package:vdm/features/users/presentation/widgets/users_loading_widget.dart';

import '../widgets/add_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('👥 UsersPage: Loading users...');
    }
    context.read<UsersBloc>().add(const LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          AppUtils.showSnackBar(context, widget.sharedPreferences.getString(AppConstants.refreshTokenKey) ?? 'refreshTokenKey');
          // AddUserDialog.show(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersActionError) {
            AppUtils.showErrorSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            // if (kDebugMode) {
            //   debugPrint('👥 UsersBloc State: $state');
            // }
            if (state is UsersLoading) {
              return const UsersLoadingWidget();
            } else if (state is UsersError) {
              return UsersErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<UsersBloc>().add(const LoadUsers());
                },
              );
            } else if (state is UsersLoaded || state is UsersActionLoading || state is UsersActionError) {
              final users = state is UsersLoaded
                  ? state.users
                  : state is UsersActionLoading
                  ? state.users
                  : (state as UsersActionError).users;
              final actionUserId = state is UsersActionLoading ? state.actionUserId : null;
              if (users.isEmpty) {
                return const UsersEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UsersBloc>().add(const LoadUsers());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isLoading = actionUserId == user.id;
                    return UserCard(
                      user: user,
                      isLoading: isLoading,
                      onToggleStatus: () {
                        context.read<UsersBloc>().add(ToggleUserStatusEvent(userId: user.id));
                      },
                      onDelete: () {
                        _showDeleteConfirmation(context, user);
                      },
                    );
                  },
                ),
              );
            }

            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User user) {
    DeleteConfirmationDialog.show(
      context,
      user: user,
      onConfirm: () {
        context.read<UsersBloc>().add(DeleteUserEvent(userId: user.id));
      },
    );
  }
}
