import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/storage_service.dart';
import '../core/constants/app_constants.dart';
import '../providers/relic_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/app_toolbar.dart';
import '../widgets/relic/sync_conflict_dialog.dart';
import '../core/services/pocketbase_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _updateFrequency = 'never';
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final frequency = StorageService.getRelicUpdateFrequency();
    if (mounted) {
      setState(() {
        _updateFrequency = frequency;
      });
    }
  }

  Future<void> _setUpdateFrequency(String frequency) async {
    await StorageService.setRelicUpdateFrequency(frequency);
    setState(() {
      _updateFrequency = frequency;
    });
  }

  Future<void> _updateRelicsNow() async {
    if (kDebugMode) print('_updateRelicsNow called');
    if (!mounted) return;
    setState(() => _isSyncing = true);
    try {
      await ref.read(relicProvider.notifier).refreshFromCloud();
      if (kDebugMode) print('_updateRelicsNow: refreshFromCloud completed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relics info updated successfully')),
        );
      }
    } catch (e) {
      if (kDebugMode) print('_updateRelicsNow failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Counters'),
        content: const Text(
          'Are you sure you want to reset all counters to zero?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(relicProvider.notifier).resetAllCounters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All counters reset')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showSyncConflictDialog() {
    if (!PocketBaseService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to sync with cloud')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SyncConflictDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppToolbar(
        title: 'Settings',
        showBackButton: true,
        onBackPressed: () => context.go(AppConstants.homeRoute),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                subtitle: Text(isDark
                    ? 'Currently in dark mode'
                    : 'Currently in light mode'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Relics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relics Info Update',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose how often to check for relics information updates',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _updateFrequency,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(
                            value: 'daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'weekly',
                            child: Text('Weekly'),
                          ),
                          DropdownMenuItem(
                            value: 'never',
                            child: Text('Never'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _setUpdateFrequency(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppConstants.maxButtonWidth),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSyncing ? null : _updateRelicsNow,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Update Relics Info Now'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  InkWell(
                    onTap: _isSyncing ? null : _showSyncConflictDialog,
                    child: ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text('Sync with Server'),
                      subtitle: const Text('Pull or push your relic counters'),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: _showResetDialog,
                    child: ListTile(
                      leading: const Icon(Icons.refresh),
                      title: const Text('Reset All Counters'),
                      subtitle: const Text('Set all relic counters to zero'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
