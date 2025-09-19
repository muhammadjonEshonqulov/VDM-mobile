import 'package:flutter/material.dart';
import 'package:vdm/features/auth/domain/entities/user.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final User user;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text(
        'Are you sure you want to delete user "${user.fullName.isNotEmpty ? user.fullName : user.username}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context, {
    required User user,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          user: user,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

