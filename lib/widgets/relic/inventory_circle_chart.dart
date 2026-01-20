import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/relic_item.dart';
import '../../providers/relic_provider.dart';

class InventoryCircleChart extends ConsumerWidget {
  const InventoryCircleChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relics = ref.watch(relicProvider);

    final inventoryData = _calculateInventoryData(relics);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircleChart(context, inventoryData),
        const SizedBox(height: 8),
        _buildLegend(context, inventoryData),
      ],
    );
  }

  List<Map<String, dynamic>> _calculateInventoryData(List<RelicItem> relics) {
    final types = ['lith', 'meso', 'neo', 'axi', 'requiem'];
    final conditions = ['intact', 'exceptional', 'flawless', 'radiant'];
    final colors = {
      'lith': _brownShades,
      'meso': _greenShades,
      'neo': _grayShades,
      'axi': _yellowShades,
      'requiem': _redShades,
    };

    final List<Map<String, dynamic>> data = [];

    for (final type in types) {
      for (int i = 0; i < conditions.length; i++) {
        final condition = conditions[i];
        int count = 0;

        for (final relic in relics) {
          if (relic.type.toLowerCase() == type) {
            switch (condition) {
              case 'intact':
                count += relic.intact;
                break;
              case 'exceptional':
                count += relic.exceptional;
                break;
              case 'flawless':
                count += relic.flawless;
                break;
              case 'radiant':
                count += relic.radiant;
                break;
            }
          }
        }

        if (count > 0) {
          data.add({
            'type': type,
            'condition': condition,
            'color': colors[type]![i],
            'count': count,
          });
        }
      }
    }

    return data;
  }

  Widget _buildCircleChart(
    BuildContext context,
    List<Map<String, dynamic>> inventoryData,
  ) {
    final totalCount =
        inventoryData.fold(0, (sum, item) => sum + item['count'] as int);

    if (totalCount == 0) {
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text('Empty', style: TextStyle(fontSize: 14)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < 180 ? 180.0 : constraints.maxWidth;
        final chartSize = size;

        return SizedBox(
          width: chartSize,
          height: chartSize,
          child: CustomPaint(
            painter: PercentageCirclePainter(
              inventoryData: inventoryData,
              totalCount: totalCount,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(
    BuildContext context,
    List<Map<String, dynamic>> inventoryData,
  ) {
    final types = [
      {'key': 'lith', 'name': 'Lith', 'color': _brownShades[3]},
      {'key': 'meso', 'name': 'Meso', 'color': _greenShades[3]},
      {'key': 'neo', 'name': 'Neo', 'color': _grayShades[3]},
      {'key': 'axi', 'name': 'Axi', 'color': _yellowShades[3]},
      {'key': 'requiem', 'name': 'Requiem', 'color': _redShades[3]},
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 10,
          runSpacing: 2,
          children: types.map((type) {
            final hasAny = inventoryData.any(
              (item) => item['type'] == type['key'] && item['count'] > 0,
            );
            if (!hasAny) return const SizedBox.shrink();

            final shades = _getShadesForType(type['key']! as String);
            final intact = inventoryData.firstWhere(
              (item) =>
                  item['type'] == type['key'] && item['condition'] == 'intact',
              orElse: () => {'count': 0},
            )['count'] as int;
            final exceptional = inventoryData.firstWhere(
              (item) =>
                  item['type'] == type['key'] &&
                  item['condition'] == 'exceptional',
              orElse: () => {'count': 0},
            )['count'] as int;
            final flawless = inventoryData.firstWhere(
              (item) =>
                  item['type'] == type['key'] &&
                  item['condition'] == 'flawless',
              orElse: () => {'count': 0},
            )['count'] as int;
            final radiant = inventoryData.firstWhere(
              (item) =>
                  item['type'] == type['key'] && item['condition'] == 'radiant',
              orElse: () => {'count': 0},
            )['count'] as int;
            final total = intact + exceptional + flawless + radiant;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: type['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  type['name'] as String,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(width: 3),
                _buildConditionDot(shades[0], intact > 0),
                const SizedBox(width: 1),
                _buildConditionDot(shades[1], exceptional > 0),
                const SizedBox(width: 1),
                _buildConditionDot(shades[2], flawless > 0),
                const SizedBox(width: 1),
                _buildConditionDot(shades[3], radiant > 0),
                const SizedBox(width: 3),
                Text(
                  '($total)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(width: 8),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildConditionDot(Color color, bool hasValue) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: hasValue ? color : color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: hasValue ? color : color.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
    );
  }

  List<Color> _getShadesForType(String type) {
    switch (type) {
      case 'lith':
        return _brownShades;
      case 'meso':
        return _greenShades;
      case 'neo':
        return _grayShades;
      case 'axi':
        return _yellowShades;
      case 'requiem':
        return _redShades;
      default:
        return _grayShades;
    }
  }

  static const _brownShades = [
    Color(0xFF5D4037),
    Color(0xFF795548),
    Color(0xFF8D6E63),
    Color(0xFFA1887F),
  ];

  static const _greenShades = [
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    Color(0xFF388E3C),
    Color(0xFF4CAF50),
  ];

  static const _grayShades = [
    Color(0xFF212121),
    Color(0xFF424242),
    Color(0xFF616161),
    Color(0xFF9E9E9E),
  ];

  static const _yellowShades = [
    Color(0xFFb3b300),
    Color(0xFFcccc00),
    Color(0xFFe6e600),
    Color(0xFFffff00),
  ];

  static const _redShades = [
    Color(0xFFB71C1C),
    Color(0xFFC62828),
    Color(0xFFD32F2F),
    Color(0xFFE57373),
  ];
}

class PercentageCirclePainter extends CustomPainter {
  final List<Map<String, dynamic>> inventoryData;
  final int totalCount;

  PercentageCirclePainter({
    required this.inventoryData,
    required this.totalCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalCount == 0 || inventoryData.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -pi / 2;

    for (final item in inventoryData) {
      final count = item['count'] as int;
      final sweepAngle = (2 * pi * count) / totalCount;

      if (sweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          Paint()..color = item['color'] as Color,
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(PercentageCirclePainter oldDelegate) {
    return oldDelegate.inventoryData != inventoryData ||
        oldDelegate.totalCount != totalCount;
  }
}
