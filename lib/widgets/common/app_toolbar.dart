import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

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
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      actions: actions,
      elevation: 0,
      flexibleSpace: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 1,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.goldFadeGradient,
          ),
        ),
      ),
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
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 1,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.goldFadeGradient,
          ),
        ),
      ),
    );
  }
}
