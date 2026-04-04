// File: lib/main.dart
import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const PrivateTutorApp());
}

/// PrivateTutor App
class PrivateTutorApp extends StatelessWidget {
  const PrivateTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PrivateTutor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Uncomment when dark theme is ready
      routerConfig: AppRouter.router,
    );
  }
}
