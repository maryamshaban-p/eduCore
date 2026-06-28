// ─── performance_overview_card.dart ──────────────────────────────────────────
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A small card that shows one motivational "get back to studying" line.
///
/// The line is picked once per app run (changes every restart / hot
/// restart) from a local bank of phrases — no API calls, no static single
/// string, no attendance/progress logic at all.
class PerformanceOverviewCard extends StatelessWidget {
  const PerformanceOverviewCard({super.key});

  // ── Motivational quotes bank ──────────────────────────────────────────
  // Keys 'study_motivation_1' .. 'study_motivation_100' must exist in your
  // translation JSON files (ar.json / en.json). One is picked randomly
  // every app (re)start. To change the count, just edit _quoteCount below.
  static const int _quoteCount = 100;

  static final List<String> _quoteKeys = List.generate(
    _quoteCount,
    (index) => 'study_motivation_${index + 1}',
  );

  // Picked once when the class is first loaded after app start,
  // and stays the same for the rest of this run.
  static final String _selectedQuoteKey =
      _quoteKeys[Random().nextInt(_quoteKeys.length)];

  static const List<IconData> _icons = [
    Icons.local_fire_department_rounded,
    Icons.menu_book_rounded,
    Icons.bolt_rounded,
    Icons.auto_awesome_rounded,
    Icons.rocket_launch_rounded,
  ];

  static final IconData _selectedIcon =
      _icons[Random().nextInt(_icons.length)];

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    const accentColor = Color(0xFF3D8FEF);

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_selectedIcon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedQuoteKey.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
