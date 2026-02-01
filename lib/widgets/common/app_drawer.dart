import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/pocketbase_service.dart';
import '../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fading_gold_divider.dart';

final Uri _url = Uri.parse(
  'https://documents.omniversify.com/warframe_tools.html',
);

class DrawerOpener extends InheritedWidget {
  final VoidCallback openDrawer;

  const DrawerOpener({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  static DrawerOpener? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DrawerOpener>();
  }

  @override
  bool updateShouldNotify(DrawerOpener oldWidget) {
    return openDrawer != oldWidget.openDrawer;
  }
}

class AppDrawer extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppDrawer({super.key, required this.child});

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerOpener(
      openDrawer: _openDrawer,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage:
                          PocketBaseService.currentUserAvatarUrl != null
                              ? NetworkImage(
                                  PocketBaseService.currentUserAvatarUrl!)
                              : null,
                      child: PocketBaseService.currentUserAvatarUrl == null
                          ? Text(
                              (PocketBaseService.currentUserName ?? 'Unknown')
                                      .isNotEmpty
                                  ? (PocketBaseService.currentUserName ??
                                          'Unknown')[0]
                                      .toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      PocketBaseService.currentUserName ?? 'Guest',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (PocketBaseService.currentUserEmail != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        PocketBaseService.currentUserEmail!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(180),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppConstants.homeRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Account'),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppConstants.accountRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppConstants.settingsRoute);
                },
              ),
              const FadingGoldDivider(verticalMargin: 8),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(context);
                  _showPrivacyDialog(context);
                },
              ),
            ],
          ),
        ),
        body: child,
      ),
    );
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.goldColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const FadingGoldDivider(horizontalMargin: 0),
          ],
        ),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', width: 64, height: 64),
              const SizedBox(height: 16),
              const Text(
                'Tools to help Warframe players and improve their experience.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Made with '),
                    WidgetSpan(
                      child: const Icon(Icons.favorite,
                          color: Colors.redAccent, size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    const TextSpan(text: ' in Morocco by Omniversify'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Version ${packageInfo.version}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Omniversify © 2026',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

void _showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Privacy Policy'),
            SizedBox(height: 8),
            FadingGoldDivider(horizontalMargin: 0),
          ],
        ),
        content: const SizedBox(
          width: 320,
          child: Text(
            "We value your privacy. Please review our detailed privacy policy to understand how we handle your data.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _launchUrl();
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text("View Policy"),
          ),
        ],
      );
    },
  );
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
