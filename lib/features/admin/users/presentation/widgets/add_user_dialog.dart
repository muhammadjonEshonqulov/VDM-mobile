import 'package:flutter/material.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Add')),
      ],
      title: const Text('Add User'),

      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (context) => AddUserDialog());
  }
}
