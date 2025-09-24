import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdm/core/navigation/navigation_config.dart';
import 'package:vdm/features/auth/presentation/bloc/auth_bloc.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navigationItems = NavigationConfig.bottomNavItems;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: navigationItems.map((item) => item.pageBuilder()).toList()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: navigationItems.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)).toList(),
      ),
      appBar: _shouldShowAppBar()
          ? AppBar(title: Text(NavigationConfig.getLabelByIndex(_currentIndex)), backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, actions: _buildAppBarActions())
          : null,
    );
  }

  bool _shouldShowAppBar() {
    // Show app bar for Settings page (index 2) and Dashboard page (index 1)
    // return _currentIndex == 1 || _currentIndex == 2;
    return true;
  }

  List<Widget> _buildAppBarActions() {
    if (_currentIndex == 2) {
      // Settings page actions
      return [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _showLogoutDialog();
          },
        ),
      ];
    }
    return [];
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        );
      },
    );
  }
}
