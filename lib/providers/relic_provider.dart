import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/legacy.dart';
import '../models/relic_item.dart';
import '../core/services/local_db_service.dart';
import '../core/services/pocketbase_service.dart';

int _naturalSortCompare(String a, String b) {
  final regex = RegExp(r'(\d+)|(\D+)');
  final aParts = regex.allMatches(a).map((m) => m.group(0)!).toList();
  final bParts = regex.allMatches(b).map((m) => m.group(0)!).toList();

  for (int i = 0; i < aParts.length && i < bParts.length; i++) {
    final aPart = aParts[i];
    final bPart = bParts[i];

    final aNum = int.tryParse(aPart);
    final bNum = int.tryParse(bPart);

    if (aNum != null && bNum != null) {
      final result = aNum.compareTo(bNum);
      if (result != 0) return result;
    } else {
      final result = aPart.compareTo(bPart);
      if (result != 0) return result;
    }
  }

  return aParts.length.compareTo(bParts.length);
}

class RelicNotifier extends StateNotifier<List<RelicItem>> {
  RelicNotifier() : super([]) {
    _loadData();
  }

  Future<void> _loadData() async {
    if (kDebugMode) print('_loadData called');
    try {
      await PocketBaseService.syncRelicInfoFromCloud();
    } catch (e) {
      if (kDebugMode) {
        print('_loadData: cloud sync failed, loading from assets');
      }
      await LocalDatabaseService.loadRelicInfoFromAssets();
    }

    final relicInfo = await LocalDatabaseService.getAllRelicInfo();
    if (kDebugMode) print('Loaded ${relicInfo.length} relics from local DB');

    final counters = await LocalDatabaseService.getAllCounters();
    if (kDebugMode) print('Loaded ${counters.length} counters');

    final relics = relicInfo.map((info) {
      final gid = info['gid'] as String;
      final unvaulted = info['unvaulted'] as bool? ?? false;
      if (kDebugMode) print('Loaded $gid - unvaulted: $unvaulted');
      final counterData = counters.firstWhere(
        (c) => c['relicGid'] == gid,
        orElse: () => {
          'relicGid': gid,
          'intact': 0,
          'exceptional': 0,
          'flawless': 0,
          'radiant': 0,
        },
      );

      return RelicItem(
        id: gid,
        name: info['name'] as String? ?? '',
        imageUrl: info['imageUrl'] as String? ?? '',
        type: info['type'] as String? ?? '',
        unvaulted: info['unvaulted'] as bool? ?? false,
        intact: counterData['intact'] as int? ?? 0,
        exceptional: counterData['exceptional'] as int? ?? 0,
        flawless: counterData['flawless'] as int? ?? 0,
        radiant: counterData['radiant'] as int? ?? 0,
        counter: (counterData['intact'] as int? ?? 0) +
            (counterData['exceptional'] as int? ?? 0) +
            (counterData['flawless'] as int? ?? 0) +
            (counterData['radiant'] as int? ?? 0),
      );
    }).toList();

    relics.sort((a, b) {
      if (a.unvaulted != b.unvaulted) {
        return a.unvaulted ? -1 : 1;
      }
      return _naturalSortCompare(a.name, b.name);
    });
    state = relics;
  }

  Future<void> refreshFromCloud() async {
    if (kDebugMode) print('refreshFromCloud called');
    if (kDebugMode) {
      print('PocketBase isConnected: ${PocketBaseService.isConnected}');
    }
    try {
      await PocketBaseService.syncRelicInfoFromCloud();
      if (kDebugMode) print('syncRelicInfoFromCloud succeeded');
    } catch (e) {
      if (kDebugMode) {
        print('_loadData: cloud sync failed, loading from assets');
      }
      await LocalDatabaseService.loadRelicInfoFromAssets();
    }
    await _loadData();
    if (kDebugMode) print('_loadData completed');
  }

  Future<void> syncCountersFromCloud() async {
    try {
      final cloudCounters = await PocketBaseService.fetchCountersFromCloud();
      for (final counter in cloudCounters) {
        await LocalDatabaseService.upsertRelicCounters(
          relicGid: counter['relicGid'],
          intact: counter['intact'],
          exceptional: counter['exceptional'],
          flawless: counter['flawless'],
          radiant: counter['radiant'],
        );
      }
      await _loadData();
    } catch (e) {
      // TO DO LATER
    }
  }

  Future<void> syncCountersToCloud() async {
    try {
      final counters = await LocalDatabaseService.getAllCounters();
      await PocketBaseService.pushAllCountersToCloud(counters);
    } catch (e) {
      // TO DO LATER
    }
  }

  void incrementCondition(String relicGid, String condition) {
    state = state.map((item) {
      if (item.id == relicGid) {
        switch (condition.toLowerCase()) {
          case 'intact':
            return item.copyWith(
              intact: item.intact + 1,
              counter: item.counter + 1,
            );
          case 'exceptional':
            return item.copyWith(
              exceptional: item.exceptional + 1,
              counter: item.counter + 1,
            );
          case 'flawless':
            return item.copyWith(
              flawless: item.flawless + 1,
              counter: item.counter + 1,
            );
          case 'radiant':
            return item.copyWith(
              radiant: item.radiant + 1,
              counter: item.counter + 1,
            );
        }
      }
      return item;
    }).toList();
    _saveSingleRelic(state.firstWhere((i) => i.id == relicGid));
    _syncSingleToCloud(relicGid);
  }

  void decrementCondition(String relicGid, String condition) {
    state = state.map((item) {
      if (item.id == relicGid) {
        switch (condition.toLowerCase()) {
          case 'intact':
            if (item.intact > 0) {
              return item.copyWith(
                intact: item.intact - 1,
                counter: item.counter - 1,
              );
            }
            break;
          case 'exceptional':
            if (item.exceptional > 0) {
              return item.copyWith(
                exceptional: item.exceptional - 1,
                counter: item.counter - 1,
              );
            }
            break;
          case 'flawless':
            if (item.flawless > 0) {
              return item.copyWith(
                flawless: item.flawless - 1,
                counter: item.counter - 1,
              );
            }
            break;
          case 'radiant':
            if (item.radiant > 0) {
              return item.copyWith(
                radiant: item.radiant - 1,
                counter: item.counter - 1,
              );
            }
            break;
        }
      }
      return item;
    }).toList();
    _saveSingleRelic(state.firstWhere((i) => i.id == relicGid));
    _syncSingleToCloud(relicGid);
  }

  void resetCondition(String relicGid, String condition) {
    state = state.map((item) {
      if (item.id == relicGid) {
        switch (condition.toLowerCase()) {
          case 'intact':
            return item.copyWith(
                intact: 0, counter: item.counter - item.intact);
          case 'exceptional':
            return item.copyWith(
                exceptional: 0, counter: item.counter - item.exceptional);
          case 'flawless':
            return item.copyWith(
                flawless: 0, counter: item.counter - item.flawless);
          case 'radiant':
            return item.copyWith(
                radiant: 0, counter: item.counter - item.radiant);
        }
      }
      return item;
    }).toList();
    _saveSingleRelic(state.firstWhere((i) => i.id == relicGid));
    _syncSingleToCloud(relicGid);
  }

  void resetAllConditions(String relicGid) {
    state = state.map((item) {
      if (item.id == relicGid) {
        return item.copyWith(
          intact: 0,
          exceptional: 0,
          flawless: 0,
          radiant: 0,
          counter: 0,
        );
      }
      return item;
    }).toList();
    _saveSingleRelic(state.firstWhere((i) => i.id == relicGid));
    _syncSingleToCloud(relicGid);
  }

  void resetAllCounters() {
    state = state
        .map((item) => item.copyWith(
              intact: 0,
              exceptional: 0,
              flawless: 0,
              radiant: 0,
              counter: 0,
            ))
        .toList();
    _saveAllData();
  }

  Future<void> _saveSingleRelic(RelicItem item) async {
    await LocalDatabaseService.upsertRelicCounters(
      relicGid: item.id,
      intact: item.intact,
      exceptional: item.exceptional,
      flawless: item.flawless,
      radiant: item.radiant,
    );
  }

  Future<void> _saveAllData() async {
    for (final item in state) {
      await LocalDatabaseService.upsertRelicCounters(
        relicGid: item.id,
        intact: item.intact,
        exceptional: item.exceptional,
        flawless: item.flawless,
        radiant: item.radiant,
      );
    }
  }

  void _syncSingleToCloud(String relicGid) async {
    try {
      final item = state.firstWhere((i) => i.id == relicGid);
      await PocketBaseService.pushCounterToCloud(relicGid, {
        'intact': item.intact,
        'exceptional': item.exceptional,
        'flawless': item.flawless,
        'radiant': item.radiant,
      });
    } catch (e) {
      // TO DO LATER
    }
  }

  List<RelicItem> getRelicsByType(String type) {
    final results = state.where((item) => item.type == type).toList();
    results.sort((a, b) => _naturalSortCompare(a.name, b.name));
    return results;
  }

  List<RelicItem> searchRelics(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    final results = state
        .where(
          (item) =>
              item.name.toLowerCase().contains(lowerQuery) ||
              item.type.toLowerCase().contains(lowerQuery),
        )
        .toList();
    results.sort((a, b) => _naturalSortCompare(a.name, b.name));
    return results;
  }
}

final relicProvider = StateNotifierProvider<RelicNotifier, List<RelicItem>>(
  (ref) => RelicNotifier(),
);

final relicByTypeProvider =
    Provider.family<List<RelicItem>, String>((ref, type) {
  return ref.watch(relicProvider).where((item) => item.type == type).toList();
});

final searchResultsProvider =
    Provider.family<List<RelicItem>, String>((ref, query) {
  return ref
      .watch(relicProvider)
      .where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.type.toLowerCase().contains(query.toLowerCase()))
      .toList();
});
