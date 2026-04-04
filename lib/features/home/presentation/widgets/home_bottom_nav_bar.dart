import 'package:flutter/material.dart';
import '../../domain/entities/home_tab.dart';

/// Home bottom navigation bar widget.
class HomeBottomNavBar extends StatelessWidget {
  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  const HomeBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentTab.index,
      onDestinationSelected: (index) {
        final tab = HomeTab.allTabs[index];
        onTabSelected(tab);
      },
      destinations: HomeTab.allTabs.map((tab) {
        return NavigationDestination(
          icon: Icon(_getIconData(tab.icon)),
          label: tab.label,
          selectedIcon: Icon(_getSelectedIconData(tab.icon)),
        );
      }).toList(),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'play_circle':
        return Icons.play_circle_outline;
      case 'history':
        return Icons.history_outlined;
      case 'person':
        return Icons.person_outline;
      default:
        return Icons.circle;
    }
  }

  IconData _getSelectedIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'play_circle':
        return Icons.play_circle;
      case 'history':
        return Icons.history;
      case 'person':
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}
