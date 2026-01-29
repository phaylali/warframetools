import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/pocketbase_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).colorScheme.surface,
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
                              style: const TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      PocketBaseService.currentUserName ?? 'Guest',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
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
                                  .onPrimaryContainer
                                  .withValues(alpha: 0.8),
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
              const Divider(),
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

    var heart = const Icon(Icons.favorite, color: Colors.redAccent);
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: packageInfo.version,
      applicationIcon:
          Image.asset('assets/images/logo.png', width: 64, height: 64),
      children: [
        const Text(
          'Tools to help Warframe players and improve their experience.',
        ),
        Row(
          children: [
            const Text('Made with '),
            heart,
            const Text(' in Morocco by Omniversify'),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Omniversify © 2026',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

void _showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.privacy_tip),
            SizedBox(width: 8),
            Text("Privacy Policy"),
          ],
        ),
        content: const Text(
          "We value your privacy. Please review our detailed privacy policy to understand how we handle your data.",
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
