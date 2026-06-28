import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/reports_models.dart';
import 'chart_card.dart';

class LineChartCard extends StatelessWidget {
  final List<EnrollmentItem> data;
  const LineChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Enrollment per Month',
      child: data.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No enrollment data yet',
                    style: TextStyle(color: AppColors.slate400, fontSize: 14)),
              ),
            )
          : SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: LineChart(_buildData()),
              ),
            ),
    );
  }

  /// Picks a "nice" step size for the Y axis based on the actual max
  /// value, instead of a hardcoded interval of 10. This keeps small
  /// datasets (e.g. max = 4) showing readable steps like 0, 2, 4...
  /// instead of jumping straight from 1 to 10 to 13.
  double _niceInterval(double maxValue) {
    if (maxValue <= 5) return 1;
    if (maxValue <= 10) return 2;
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    return 20;
  }

  LineChartData _buildData() {
    final rawMax = data.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final interval = _niceInterval(rawMax);
    // Round the top of the chart up to the next clean multiple of the
    // interval, with a little headroom, so the last label isn't cut.
    final maxY = ((rawMax / interval).ceil() + 1) * interval;

    return LineChartData(
      minY: 0,
      maxY: maxY,
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: AppColors.slate200, strokeWidth: 1, dashArray: [4, 4]),
      ),
      borderData: FlBorderData(show: false),
      titlesData: _buildTitles(interval, maxY),
      lineBarsData: [_buildBar()],
    );
  }

  String _shortLabel(String raw) {
    if (raw.length <= 10) return raw;
    return '${raw.substring(0, 8)}…';
  }

  FlTitlesData _buildTitles(double interval, double maxY) {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: interval,
        getTitlesWidget: (v, _) => Text(v.toInt().toString(),
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.slate400)),
      )),
      bottomTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 44,
        getTitlesWidget: (v, meta) {
          final i = v.toInt();
          if (i < 0 || i >= data.length) return const SizedBox();
          return SideTitleWidget(
            meta: meta,
            space: 10,
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                _shortLabel(data[i].label),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.slate400,
                ),
              ),
            ),
          );
        },
      )),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
  LineChartBarData _buildBar() {
    return LineChartBarData(
      spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i].count)),
      isCurved: true, color: AppColors.primary, barWidth: 2.5,
      dotData: FlDotData(
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: 4, color: AppColors.primary, strokeWidth: 2, strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
          show: true, color: AppColors.primary.withValues(alpha: 0.08)),
    );
  }
}
