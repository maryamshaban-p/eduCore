import 'package:edulink_app/platform/Admin1/features/reports/data/reports_models.dart';
import 'package:edulink_app/platform/Admin1/features/reports/widgets/charts/chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:edulink_app/core/theme/app_theam.dart';


class PieChartCard extends StatelessWidget {
  final List<TeacherShare> data;
  const PieChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Students per Teacher',
      child: data.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No data yet',
                    style: TextStyle(color: AppColors.slate400, fontSize: 14)),
              ),
            )
          : Column(children: [
              SizedBox(height: 220, child: PieChart(_buildData())),
              const SizedBox(height: 20),
              _Legend(data: data),
            ]),
    );
  }

  PieChartData _buildData() {
    final total = data.fold<double>(0, (sum, d) => sum + d.value);
    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 0,
      sections: data.map((d) {
        final pct = total > 0 ? (d.value / total * 100).toStringAsFixed(0) : '0';
        return PieChartSectionData(
          value: d.value,
          color: Color(d.colorHex),
          title: '$pct%',
          titlePositionPercentageOffset: 0.6,
          titleStyle: const TextStyle(
              fontFamily: 'Inter', fontSize: 13,
              fontWeight: FontWeight.w600, color: Colors.white),
          radius: 90,
        );
      }).toList(),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<TeacherShare> data;
  const _Legend({required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: data.map((d) => _LegendItem(item: d)).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final TeacherShare item;
  const _LegendItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(color: Color(item.colorHex), shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(item.name,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate600)),
    ]);
  }
}