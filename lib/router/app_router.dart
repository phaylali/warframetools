import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../screens/relic_counter_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/common/app_drawer.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppDrawer(child: child),
      routes: [
        GoRoute(
          path: AppConstants.homeRoute,
          name: 'home',
          pageBuilder: (context, state) => MaterialPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppConstants.relicCounterRoute,
          name: 'relic-counter',
          pageBuilder: (context, state) =>
              MaterialPage(child: RelicCounterScreen()),
        ),
        GoRoute(
          path: AppConstants.settingsRoute,
          name: 'settings',
          pageBuilder: (context, state) =>
              MaterialPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);
