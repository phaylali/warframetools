import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../screens/relic_counter_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/account_screen.dart';
import '../screens/password_reset_screen.dart';
import '../widgets/common/app_drawer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
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
        GoRoute(
          path: AppConstants.accountRoute,
          name: 'account',
          pageBuilder: (context, state) => MaterialPage(child: AccountScreen()),
        ),
        GoRoute(
          path: '/password-reset',
          name: 'password-reset',
          pageBuilder: (context, state) =>
              MaterialPage(child: PasswordResetScreen()),
        ),
      ],
    ),
  ],
);
