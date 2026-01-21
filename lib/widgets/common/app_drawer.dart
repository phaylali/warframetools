import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
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
                    Icon(
                      Icons.games,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
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

  void _showAboutDialog(BuildContext context) {
    var heart = const Icon(Icons.favorite, color: Colors.redAccent);
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: '1.0.1',
      applicationIcon: const Icon(Icons.games, size: 64),
      children: [
        const Text(
          'A helper app for Warframe players with useful tools and counters.',
        ),
        Row(
          children: [
            const Text('Made with '),
            heart,
            const Text(' in Morocco by Omniversify'),
          ],
        ),
      ],
    );
  }
}

void _showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SimpleDialog(
        title: Text("Privacy Policy"),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
            child: FilledButton(
              onPressed: _launchUrl,
              child: Text("Check Privacy Policy"),
            ),
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
