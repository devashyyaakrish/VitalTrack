import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/components/glass_bottom_nav.dart';
import '../../core/components/gradient_scaffold.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScreen({super.key, required this.child, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: child,
      bottomNavigationBar: GlassBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
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
