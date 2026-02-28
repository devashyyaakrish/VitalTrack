import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScreen({super.key, required this.child, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon: Icon(CupertinoIcons.house_fill),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.drop),
              activeIcon: Icon(CupertinoIcons.drop_fill),
              label: 'Trackers',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.check_mark_circled),
              activeIcon: Icon(CupertinoIcons.check_mark_circled_solid),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              activeIcon: Icon(CupertinoIcons.chart_bar_alt_fill),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              activeIcon: Icon(CupertinoIcons.settings_solid),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/trackers');
        break;
      case 2:
        context.go('/habits');
        break;
      case 3:
        context.go('/analytics');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
