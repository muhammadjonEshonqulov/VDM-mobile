import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdm/core/utils/app_utils.dart';
import 'package:vdm/core/widgets/empty_widget.dart';
import 'package:vdm/core/widgets/errors_widget.dart';
import 'package:vdm/core/widgets/loading_widget.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';
import 'package:vdm/features/users/presentation/bloc/users_bloc.dart';
import 'package:vdm/features/users/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:vdm/features/users/presentation/widgets/user_card.dart';

import '../widgets/add_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();

    context.read<UsersBloc>().add(const LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddUserDialog.show(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<UsersBloc, UsersState>(
        listenWhen: (previous, current) => current is UsersActionError,
        listener: (context, state) {
          if (state is UsersActionError) {
            AppUtils.showErrorSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const LoadingWidget(message: 'Loading users...');
            } else if (state is UsersError) {
              return ErrorWidget(
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
                return const EmptyWidget();
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
