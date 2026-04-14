import 'package:equatable/equatable.dart';

/// Home tab enumeration for bottom navigation.
class HomeTab extends Equatable {
  final int index;
  final String name;
  final String icon;
  final String label;

  const HomeTab._({
    required this.index,
    required this.name,
    required this.icon,
    required this.label,
  });

  static const home = HomeTab._(
    index: 0,
    name: 'home',
    icon: 'home',
    label: 'Home',
  );

  static const courses = HomeTab._(
    index: 1,
    name: 'courses',
    icon: 'school',
    label: 'Courses',
  );

  static const myLearning = HomeTab._(
    index: 2,
    name: 'my_learning',
    icon: 'play_circle',
    label: 'My Learning',
  );

  static const profile = HomeTab._(
    index: 3,
    name: 'profile',
    icon: 'person',
    label: 'Profile',
  );

  static const List<HomeTab> allTabs = [
    home,
    courses,
    myLearning,
    // activity,
    profile,
  ];

  @override
  List<Object?> get props => [index, name, icon, label];
}
