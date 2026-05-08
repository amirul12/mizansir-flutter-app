// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;

  // Initialize dependency injection
  await di.init();

  runApp(const MizanSirApp());
}

/// Mizan Sir App
class MizanSirApp extends StatelessWidget {
  const MizanSirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mizan Sir',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
       // darkTheme: AppTheme.darkTheme, // Uncomment when dark theme is ready
      routerConfig: AppRouter.router,
    );
  }
}
