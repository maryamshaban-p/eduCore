import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

typedef EnrollmentEntry = ({String subject, double value});

class EnrollmentChartBuilder {
  static BarChartData build(List<EnrollmentEntry> data) {
    // لو مفيش data خليه فاضي
    if (data.isEmpty) {
      return BarChartData(
        barGroups: [],
        borderData: FlBorderData(show: false),
      );
    }

    final rawMax = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final interval = _niceInterval(rawMax);
    // Round up to the next clean multiple of the interval, plus one
    // extra step of headroom, so the top bar/label isn't cramped.
    final maxY = ((rawMax / interval).ceil() + 1) * interval;

    return BarChartData(
      maxY: maxY,
      barTouchData: _touchData(data),
      gridData: _gridData(),
      borderData: FlBorderData(show: false),
      titlesData: _titlesData(data, interval),
      barGroups: List.generate(data.length, (i) => _barGroup(i, data)),
    );
  }

  /// Picks a "nice" step size for the Y axis based on the actual max
  /// value, instead of a hardcoded interval of 20. This keeps small
  /// datasets showing readable steps like 0, 5, 10... instead of
  /// jumping in big chunks of 20.
  static double _niceInterval(double maxValue) {
    if (maxValue <= 5) return 1;
    if (maxValue <= 10) return 2;
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    return 50;
  }

  /// Shortens long subject names/IDs so the x-axis stays readable
  /// even when rotated.
  static String _shortLabel(String raw) {
    if (raw.length <= 12) return raw;
    return '${raw.substring(0, 10)}…';
  }

  static BarTouchData _touchData(List<EnrollmentEntry> data) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.all(8),
        tooltipBorder: const BorderSide(color: AppColors.slate200),
        getTooltipColor: (_) => Colors.white,
        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
          '${data[group.x].subject}\n',
          const TextStyle(color: AppColors.slate800, fontWeight: FontWeight.bold, fontSize: 12),
          children: [TextSpan(text: 'Students: ${rod.toY.toInt()}', style: const TextStyle(color: AppColors.primary, fontSize: 11))],
        ),
      ),
    );
  }

  static FlGridData _gridData() {
    return FlGridData(
      show: true, drawVerticalLine: false,
      getDrawingHorizontalLine: (_) => FlLine(color: AppColors.slate200, strokeWidth: 1, dashArray: [4, 4]),
    );
  }

  static FlTitlesData _titlesData(List<EnrollmentEntry> data, double interval) {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: interval,
        getTitlesWidget: (v, _) => Text(v.toInt().toString(),
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.slate400)),
      )),
      bottomTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 44, // extra room for the rotated label
        getTitlesWidget: (v, meta) {
          final i = v.toInt();
          if (i < 0 || i >= data.length) return const SizedBox();
          return SideTitleWidget(
            meta: meta,
            space: 10,
            // Rotate so names don't collide with each other when
            // there are many bars or the subject names are long.
            child: Transform.rotate(
              angle: -0.5, // ~ -28 degrees
              child: Text(
                _shortLabel(data[i].subject),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.slate500),
              ),
            ),
          );
        },
      )),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
  static BarChartGroupData _barGroup(int i, List<EnrollmentEntry> data) {
    return BarChartGroupData(x: i, barRods: [
      BarChartRodData(
        toY: data[i].value, color: AppColors.primary, width: 44,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
    ]);
  }
}