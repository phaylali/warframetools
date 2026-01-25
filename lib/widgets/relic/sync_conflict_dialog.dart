import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/pocketbase_service.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/relic_provider.dart';

class SyncConflictDialog extends ConsumerStatefulWidget {
  const SyncConflictDialog({super.key});

  @override
  ConsumerState<SyncConflictDialog> createState() => _SyncConflictDialogState();
}

class _SyncConflictDialogState extends ConsumerState<SyncConflictDialog> {
  bool _isLoading = true;
  Map<String, dynamic> _cloudData = {};
  int _localTotal = 0;
  int _cloudTotal = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchComparison();
  }

  Future<void> _fetchComparison() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cloudData = await PocketBaseService.getCloudCounters();

      // Calculate totals
      int localCount = 0;
      final localData = ref.read(relicProvider);
      for (final item in localData) {
        if (item.counter > 0) localCount++;
      }

      int cloudCount = cloudData.keys.length;

      if (mounted) {
        setState(() {
          _cloudData = cloudData;
          _localTotal = localCount;
          _cloudTotal = cloudCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to fetch cloud data: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onUseCloud() async {
    final confirmed = await _showConfirmDialog(
      'Use Cloud Data',
      'This will OVERWRITE your local data with data from the cloud. This action cannot be undone.',
      Icons.cloud_download,
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await ref.read(relicProvider.notifier).applySparseJson(_cloudData);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _onUseLocal() async {
    final confirmed = await _showConfirmDialog(
      'Use Local Data',
      'This will OVERWRITE your cloud backup with your current local data. This action cannot be undone.',
      Icons.cloud_upload,
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await ref.read(relicProvider.notifier).syncCountersToCloud();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _onMerge() async {
    final confirmed = await _showConfirmDialog(
      'Merge Data',
      'This will combine both local and cloud data, keeping the highest counter for each relic.',
      Icons.merge_type,
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await ref.read(relicProvider.notifier).mergeWithSparseJson(_cloudData);
      // After merging locally, push the merged result back to cloud
      await ref.read(relicProvider.notifier).syncCountersToCloud();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<bool?> _showConfirmDialog(
      String title, String message, IconData icon) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(icon),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cloud Sync'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorState()
                : _buildSyncOptions(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Sync Check Failed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _fetchComparison,
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxButtonWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.sync_problem, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Sync Your Data',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose how you want to reconcile your relic counters between this device and your account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildDataCard(
                'Local Data',
                '$_localTotal relics owned',
                Icons.phone_android,
                _onUseLocal,
                'Upload to Cloud',
              ),
              const SizedBox(height: 16),
              _buildDataCard(
                'Cloud Data',
                '$_cloudTotal relics owned',
                Icons.cloud_done,
                _onUseCloud,
                'Download to Device',
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _onMerge,
                icon: const Icon(Icons.merge_type),
                label: const Text('Merge Both (Safe)'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Skip & Decide Later'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onAction,
    String actionLabel,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
