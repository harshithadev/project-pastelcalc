import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/calculation_entry.dart';
import '../theme/pastel_theme.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    super.key,
    required this.entries,
    required this.onReuse,
    required this.onDelete,
    required this.onDeleteAll,
    required this.onClose,
  });

  final List<CalculationEntry> entries;
  final ValueChanged<CalculationEntry> onReuse;
  final ValueChanged<String> onDelete;
  final VoidCallback onDeleteAll;
  final VoidCallback onClose;

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PastelColors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: PastelColors.textSecondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.clock, color: PastelColors.textPrimary),
                  const SizedBox(width: 8),
                  Text('History', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  if (entries.isNotEmpty)
                    TextButton.icon(
                      onPressed: onDeleteAll,
                      icon: const Icon(CupertinoIcons.trash, size: 18),
                      label: const Text('Clear all'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFD84343),
                      ),
                    ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(CupertinoIcons.xmark_circle_fill),
                    color: PastelColors.textSecondary,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.sparkles,
                            size: 42,
                            color: PastelColors.lavender.withValues(alpha: 0.8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No calculations yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your results will appear here',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Dismissible(
                          key: ValueKey(entry.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: PastelColors.danger,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              CupertinoIcons.delete,
                              color: Color(0xFF8B2E2E),
                            ),
                          ),
                          onDismissed: (_) => onDelete(entry.id),
                          child: Material(
                            color: PastelColors.displayBg,
                            borderRadius: BorderRadius.circular(18),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => onReuse(entry),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.expression,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: PastelColors.textSecondary,
                                                  fontSize: 13,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '= ${entry.result}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _formatTime(entry.timestamp),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
