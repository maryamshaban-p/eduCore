// ─── statistics_card.dart ─────────────────────────────────────────────────────
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/home/widgets/statistcs_list_tile.dart';
import 'package:edulink_app/students/features/home/widgets/statistic_circle.dart';
import 'package:edulink_app/students/features/home/data/home_model.dart';
import 'package:edulink_app/students/features/acheivement/views/statistics_view_screen.dart';
import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final HomeStatistics statistics;
  final String academicLevel;

  const StatisticsCard({
    super.key,
    required this.statistics,
    required this.academicLevel,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'January – June 2026'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3D8FEF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => StatisticsViewScreen()),
                  ),
                  child: Text('Details'.tr()),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),

            // ── Body ─────────────────────────────────────────────────
            isTablet ? _wideBody() : _narrowBody(),
          ],
        ),
      ),
    );
  }

  Widget _wideBody() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: _tiles(),
          ),
        ),
        const SizedBox(width: 16),
        StatisticCircle(
          percentage: statistics.overallProgress,
          radius: 85,
        ),
      ],
    );
  }

  Widget _narrowBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(children: _tiles()),
            ),
            StatisticCircle(
              percentage: statistics.overallProgress,
              radius: 70,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _tiles() => [
        _StatTile(
          color: const Color(0xFF3D8FEF),
          icon: Icons.person_outline_rounded,
          title: 'Absence'.tr(),
          value:
              'absence_days'.tr(namedArgs: {'count': '${statistics.absence}'}),
        ),
        const SizedBox(height: 8),
        // _StatTile(
        //   color: const Color(0xFF34C759),
        //   icon: Icons.task_alt_rounded,
        //   title: 'Tasks Submitted'.tr(),
        //  // value: '${statistics.tasksSubmitted}',
        // ),
        const SizedBox(height: 8),
        _StatTile(
          color: const Color(0xFFFF9500),
          icon: Icons.quiz_outlined,
          title: 'Quizzes Taken'.tr(),
          value: '${statistics.quizzesTaken}',
        ),
        const SizedBox(height: 8),
        _StatTile(
          color: const Color(0xFF7C6FE0),
          icon: Icons.school_outlined,
          title: 'Academic Level'.tr(),
          value: academicLevel.isEmpty ? '—' : academicLevel,
        ),
      ];
}

class _StatTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  const _StatTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}