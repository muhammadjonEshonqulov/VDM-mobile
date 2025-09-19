import 'package:flutter/material.dart';

class UsersLoadingWidget extends StatelessWidget {
  const UsersLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

