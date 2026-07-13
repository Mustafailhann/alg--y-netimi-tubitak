import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RealityLensApp(),
    ),
  );
}

class RealityLensApp extends ConsumerWidget {
  const RealityLensApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'RealityLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.studentTheme(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
