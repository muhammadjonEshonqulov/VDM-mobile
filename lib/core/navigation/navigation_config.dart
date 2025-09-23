import 'package:flutter/material.dart';

import '../../features/users/presentation/pages/users_page.dart';
import '../di/injection_container.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget Function() pageBuilder;
  final String? route;

  const NavigationItem({required this.icon, required this.label, required this.pageBuilder, this.route});
}

class NavigationConfig {
  static List<NavigationItem> get bottomNavItems => [
    NavigationItem(icon: Icons.people, label: 'Users', pageBuilder: () => UsersPage(sharedPreferences: sl(),), route: '/main/users'),
    NavigationItem(icon: Icons.dashboard, label: 'Dashboard', pageBuilder: () => const DashboardPage(), route: '/main/dashboard'),
    NavigationItem(icon: Icons.settings, label: 'Settings', pageBuilder: () => const SettingsPage(), route: '/main/settings'),
  ];

  static Widget getPageByIndex(int index) {
    if (index < 0 || index >= bottomNavItems.length) {
      return const Center(child: Text('Page not found'));
    }
    return bottomNavItems[index].pageBuilder();
  }

  static String getLabelByIndex(int index) {
    if (index < 0 || index >= bottomNavItems.length) {
      return 'Unknown';
    }
    return bottomNavItems[index].label;
  }
}

// Placeholder pages - these should be implemented as separate features
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text('This page will be implemented soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text('Settings page will be implemented soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
