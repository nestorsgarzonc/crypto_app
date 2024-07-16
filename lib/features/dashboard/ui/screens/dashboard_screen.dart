import 'package:crypto_app/features/dashboard/ui/tabs/compare_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/favorites_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/home_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/profile_tab.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const route = '/';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [HomeTab(), FavoritesTab(), CompareTab(), ProfileTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.compare_arrows), label: 'Compare'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
