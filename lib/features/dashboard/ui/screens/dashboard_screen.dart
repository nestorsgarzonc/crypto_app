import 'package:crypto_app/features/dashboard/ui/tabs/compare_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/favorites_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/home_tab.dart';
import 'package:crypto_app/features/dashboard/ui/tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  static const route = '/';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _idx = 0;
  int get _selectedIndex => _idx;
  set _selectedIndex(int idx) {
    setState(() => _idx = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomeTab(),
        const FavoritesTab(),
        const CompareTab(),
        const ProfileTab()
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => _selectedIndex = idx,
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
