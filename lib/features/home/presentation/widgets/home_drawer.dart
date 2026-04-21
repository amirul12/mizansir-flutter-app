import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/home_shell_cubit.dart';

/// Home drawer widget with full navigation menu.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileBloc>().state;
    final profile = profileState is ProfileLoaded
        ? profileState.profile
        : null;

    return Drawer(
      child: ListView(
        children: [
          // Header
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                profile?.initials ?? 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            accountName: Text(profile?.name ?? 'Guest'),
            accountEmail: Text(profile?.email ?? ''),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Main Navigation
          _buildDrawerSection(context, 'Main', [
            _DrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                context.read<HomeShellCubit>().goToHome();
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.school,
              title: 'Courses',
              onTap: () {
                Navigator.pop(context);
                context.go('/courses');
              },
            ),
            _DrawerItem(
              icon: Icons.star,
              title: 'Featured Courses',
              onTap: () {
                // Navigate to featured courses
                Navigator.pop(context);
                context.go('/courses?featured=true');
              },
            ),
            _DrawerItem(
              icon: Icons.category,
              title: 'Categories',
              onTap: () {
                Navigator.pop(context);
                context.go('/categories');
              },
            ),
            _DrawerItem(
              icon: Icons.play_circle,
              title: 'My Learning',
              onTap: () {
                context.read<HomeShellCubit>().goToMyLearning();
                Navigator.pop(context);
              },
            ),
          ]),

          const Divider(),

          // Account Section
          _buildDrawerSection(context, 'Account', [
            _DrawerItem(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                context.read<HomeShellCubit>().goToProfile();
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.pop(context);
                // Navigate to change password
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password coming soon')),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.devices,
              title: 'Active Sessions',
              onTap: () {
                Navigator.pop(context);
                // Navigate to sessions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Active sessions coming soon')),
                );
              },
            ),
          ]),

          const Divider(),

          // System Section
          _buildDrawerSection(context, 'System', [
            _DrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon')),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.info,
              title: 'About Mizan Sir',
              onTap: () {
                Navigator.pop(context);
                context.go('/about-mizan-sir');
              },
            ),
            _DrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(BuildContext context, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final navigator = GoRouter.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(dialogContext);

              // Listen for logout completion
              StreamSubscription? subscription;
              subscription = authBloc.stream.listen((state) {
                if (state is AuthUnauthenticated) {
                  // Navigate to login page after logout completes
                  navigator.go('/login');
                  subscription?.cancel();
                } else if (state is AuthError) {
                  // Show error if logout fails
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  subscription?.cancel();
                }
              });

              // Trigger logout
              authBloc.add(LogoutEvent());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
