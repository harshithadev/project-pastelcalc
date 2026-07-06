import 'package:flutter/material.dart';

import '../theme/pastel_theme.dart';

class DisplayPanel extends StatelessWidget {
  const DisplayPanel({
    super.key,
    required this.expression,
    required this.display,
    this.error,
  });

  final String expression;
  final String display;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isError = error != null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final displayFontSize = screenWidth > 600 ? 52.0 : screenWidth > 380 ? 44.0 : 36.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: PastelColors.displayBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 2),
        boxShadow: [
          BoxShadow(
            color: PastelColors.lavender.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (expression.isNotEmpty && expression != display)
            Text(
              expression,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: PastelColors.textSecondary,
                  ),
            ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              isError ? error! : display,
              key: ValueKey(isError ? error : display),
              maxLines: 3,
              overflow: TextOverflow.fade,
              softWrap: true,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: displayFontSize,
                    color: isError ? const Color(0xFFD84343) : PastelColors.textPrimary,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Supports real & complex · tap i for √−1',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
