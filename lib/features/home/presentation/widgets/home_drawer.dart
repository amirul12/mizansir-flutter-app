import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Import Blocs
import 'package:mizansir/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mizansir/features/auth/presentation/bloc/auth_event.dart';
import 'package:mizansir/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mizansir/features/profile/presentation/bloc/profile_state.dart';
import 'package:mizansir/features/home/presentation/bloc/home_shell_cubit.dart';
import 'package:mizansir/core/theme/app_colors.dart';

/// Home drawer widget with full navigation menu.
class HomeDrawer extends StatelessWidget {
  final VoidCallback? onLogout;
  const HomeDrawer({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildSectionTitle('Main Menu'),
                _buildDrawerItem(
                  context,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  onTap: () {
                    context.read<HomeShellCubit>().goToHome();
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.school_rounded,
                  label: 'Courses',
                  onTap: () {
                    context.read<HomeShellCubit>().goToCourses();
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.play_circle_outline_rounded,
                  label: 'My Learning',
                  onTap: () {
                    context.read<HomeShellCubit>().goToMyLearning();
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildSectionTitle('Account'),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () {
                    context.read<HomeShellCubit>().goToProfile();
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/change-password');
                  },
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildSectionTitle('Others'),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  label: 'About Mizan Sir',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/about-mizan-sir');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    if (onLogout != null) {
                      onLogout!();
                    } else {
                      _showLogoutDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state is ProfileLoaded ? state.profile : null;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: profile?.user?.avatarUrl != null && profile!.user!.avatarUrl!.isNotEmpty
                      ? Image.network(profile!.user!.avatarUrl!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.person, size: 40, color: AppColors.primary),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile?.user?.name ?? 'Loading...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile?.user?.email ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final primaryColor = color ?? AppColors.textPrimary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: primaryColor.withValues(alpha: 0.8), size: 24),
        title: Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Opacity(
            opacity: 0.4,
            child: Text(
              'v1.0.0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/icons/logo.png',
            height: 30,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Stay', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              authBloc.add(LogoutEvent());
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
