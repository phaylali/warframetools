import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../screens/relic_counter_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppConstants.relicCounterRoute,
      name: 'relic-counter',
      builder: (context, state) => const RelicCounterScreen(),
    ),
  ],
);