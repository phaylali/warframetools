import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import '../models/relic_item.dart';
import '../providers/relic_provider.dart';
import '../widgets/common/app_drawer.dart';
import '../widgets/common/theme_toggle_button.dart';
import '../widgets/relic/relic_item_card.dart';

final selectedFilterProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

class RelicCounterScreen extends ConsumerWidget {
  const RelicCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relicItems = ref.watch(relicProvider);
    final relicNotifier = ref.read(relicProvider.notifier);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // ignore: unused_local_variable
    final totalCount =
        relicItems.fold<int>(0, (sum, item) => sum + item.counter);
    final lithCount = relicItems
        .where((item) => item.type.toLowerCase() == 'lith')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final mesoCount = relicItems
        .where((item) => item.type.toLowerCase() == 'meso')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final neoCount = relicItems
        .where((item) => item.type.toLowerCase() == 'neo')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final axiCount = relicItems
        .where((item) => item.type.toLowerCase() == 'axi')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final requiemCount = relicItems
        .where((item) => item.type.toLowerCase() == 'requiem')
        .fold<int>(0, (sum, item) => sum + item.counter);

    final inventoryCount =
        relicItems.fold<int>(0, (sum, item) => sum + item.counter);

    final filteredItems = searchQuery.isEmpty && selectedFilter == 'All'
        ? relicItems
        : selectedFilter == 'Inventory'
            ? relicNotifier
                .searchRelics(searchQuery)
                .where((item) => item.counter > 0)
                .toList()
            : relicNotifier.searchRelics(searchQuery).where((item) {
                if (selectedFilter == 'All') return true;
                return item.type.toLowerCase() == selectedFilter.toLowerCase();
              }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relic Counter'),
        actions: [
          IconButton(
            onPressed: () => _showResetDialog(context, relicNotifier),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset All Counters',
          ),
          IconButton(
            onPressed: () => _showStatsDialog(context, relicItems),
            icon: const Icon(Icons.analytics),
            tooltip: 'Stats',
          ),
          IconButton(
            onPressed: () => _showSyncDialog(context, relicNotifier),
            icon: const Icon(Icons.cloud_sync),
            tooltip: 'Sync with Server',
          ),
          const ThemeToggleButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search relics...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  clipBehavior: Clip.none,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildFilterChip(
                        context,
                        'Inventory',
                        inventoryCount,
                        selectedFilter == 'Inventory',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Inventory';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'All',
                        0,
                        selectedFilter == 'All',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'All';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'Lith',
                        lithCount,
                        selectedFilter == 'Lith',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Lith';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'Meso',
                        mesoCount,
                        selectedFilter == 'Meso',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Meso';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'Neo',
                        neoCount,
                        selectedFilter == 'Neo',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Neo';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'Axi',
                        axiCount,
                        selectedFilter == 'Axi',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Axi';
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip(
                        context,
                        'Requiem',
                        requiemCount,
                        selectedFilter == 'Requiem',
                        () {
                          ref.read(selectedFilterProvider.notifier).state =
                              'Requiem';
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                if (selectedFilter != "All" && selectedFilter != 'Inventory')
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      'Total $selectedFilter Relics: ${_getTotalRelicsByType(relicItems, selectedFilter)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                if (selectedFilter == "All")
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      'Total Relics: ${relicItems.length}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: relicItems.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return RelicItemCard(
                        item: item,
                        onIncrementIntact: () =>
                            relicNotifier.incrementCondition(item.id, 'intact'),
                        onDecrementIntact: () =>
                            relicNotifier.decrementCondition(item.id, 'intact'),
                        onIncrementExceptional: () => relicNotifier
                            .incrementCondition(item.id, 'exceptional'),
                        onDecrementExceptional: () => relicNotifier
                            .decrementCondition(item.id, 'exceptional'),
                        onIncrementFlawless: () => relicNotifier
                            .incrementCondition(item.id, 'flawless'),
                        onDecrementFlawless: () => relicNotifier
                            .decrementCondition(item.id, 'flawless'),
                        onIncrementRadiant: () => relicNotifier
                            .incrementCondition(item.id, 'radiant'),
                        onDecrementRadiant: () => relicNotifier
                            .decrementCondition(item.id, 'radiant'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getTotalRelicsByType(List<RelicItem> items, String type) {
    return items
        .where((item) => item.type.toLowerCase() == type.toLowerCase())
        .length;
  }

  void _showResetDialog(BuildContext context, RelicNotifier notifier) {
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
              notifier.resetAllCounters();
              Navigator.pop(context);
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

  void _showStatsDialog(BuildContext context, List<RelicItem> relicItems) {
    final totalItems = relicItems.fold<int>(
      0,
      (sum, item) => sum + item.counter,
    );
    final nonZeroItems = relicItems.where((item) => item.counter > 0).length;

    final lithCount = relicItems
        .where((item) => item.type.toLowerCase() == 'lith')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final mesoCount = relicItems
        .where((item) => item.type.toLowerCase() == 'meso')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final neoCount = relicItems
        .where((item) => item.type.toLowerCase() == 'neo')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final axiCount = relicItems
        .where((item) => item.type.toLowerCase() == 'axi')
        .fold<int>(0, (sum, item) => sum + item.counter);
    final requiemCount = relicItems
        .where((item) => item.type.toLowerCase() == 'requiem')
        .fold<int>(0, (sum, item) => sum + item.counter);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistics'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Relics Owned: $totalItems'),
              Text('Relic Types Owned: $nonZeroItems'),
              Text('Total Relic Types: ${relicItems.length}'),
              const Divider(),
              Text('Lith: $lithCount'),
              Text('Meso: $mesoCount'),
              Text('Neo: $neoCount'),
              Text('Axi: $axiCount'),
              Text('Requiem: $requiemCount'),
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

  void _showSyncDialog(BuildContext context, RelicNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync with Server'),
        content: const Text(
          'Choose sync direction:',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.syncCountersFromCloud();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Synced from server')),
                );
              }
            },
            child: const Text('Pull from Server'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.syncCountersToCloud();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Synced to server')),
                );
              }
            },
            child: const Text('Push to Server'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
