import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/relic_item.dart';

class RelicItemCard extends StatelessWidget {
  final RelicItem item;
  final VoidCallback onIncrementIntact;
  final VoidCallback onDecrementIntact;
  final VoidCallback onIncrementExceptional;
  final VoidCallback onDecrementExceptional;
  final VoidCallback onIncrementFlawless;
  final VoidCallback onDecrementFlawless;
  final VoidCallback onIncrementRadiant;
  final VoidCallback onDecrementRadiant;

  const RelicItemCard({
    super.key,
    required this.item,
    required this.onIncrementIntact,
    required this.onDecrementIntact,
    required this.onIncrementExceptional,
    required this.onDecrementExceptional,
    required this.onIncrementFlawless,
    required this.onDecrementFlawless,
    required this.onIncrementRadiant,
    required this.onDecrementRadiant,
  });

  Future<void> _launchWikiUrl(String input) async {
    final name = input.replaceAll(' ', '_');
    final url = Uri.parse('https://wiki.warframe.com/w/$name');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch the url');
    }
  }

  void _showImagePreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(item.name),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 200,
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _launchWikiUrl(item.name);
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('More Info'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(bool isCyan, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCyan ? Colors.cyan : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isCyan
                ? Colors.cyan.shade700
                : Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildConditionColumn({
    required BuildContext context,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required Widget? indicator,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator ?? const SizedBox(height: 20),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.ideographic,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: count > 0 ? onDecrement : null,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.remove_circle_outline,
              size: 20,
              color: count > 0
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () => _showImagePreviewDialog(context),
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 52,
                  height: 52,
                  placeholder: (context, url) => Container(
                    width: 52,
                    height: 52,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image, size: 28),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 52,
                    height: 52,
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Icon(
                      Icons.broken_image,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    item.unvaulted ? 'unvaulted' : 'vaulted',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: item.unvaulted
                              ? Colors.green
                              : Colors.red.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildConditionColumn(
                  context: context,
                  count: item.intact,
                  onIncrement: onIncrementIntact,
                  onDecrement: onDecrementIntact,
                  indicator: _buildCircle(false, context, onIncrementIntact),
                ),
                const SizedBox(width: 8),
                _buildConditionColumn(
                  context: context,
                  count: item.exceptional,
                  onIncrement: onIncrementExceptional,
                  onDecrement: onDecrementExceptional,
                  indicator:
                      _buildCircle(true, context, onIncrementExceptional),
                ),
                const SizedBox(width: 8),
                _buildConditionColumn(
                  context: context,
                  count: item.flawless,
                  onIncrement: onIncrementFlawless,
                  onDecrement: onDecrementFlawless,
                  indicator: _buildCircle(true, context, onIncrementFlawless),
                ),
                const SizedBox(width: 8),
                _buildConditionColumn(
                  context: context,
                  count: item.radiant,
                  onIncrement: onIncrementRadiant,
                  onDecrement: onDecrementRadiant,
                  indicator: _buildCircle(true, context, onIncrementRadiant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
