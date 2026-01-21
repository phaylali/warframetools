import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;

  const AppToolbar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _defaultBackAction(BuildContext context) {
    context.go(AppConstants.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? _buildLeading(context),
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
      ),
      centerTitle: true,
      actions: actions,
      elevation: 0,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        onPressed: onBackPressed ?? () => _defaultBackAction(context),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
      );
    }
    return null;
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const HomeAppBar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onMenuPressed,
        icon: const Icon(Icons.menu),
        tooltip: 'Menu',
      ),
      title: Text(
        AppConstants.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
            Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
