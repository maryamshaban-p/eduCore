import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_Card.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomPieChartCard extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;

  const CustomPieChartCard({
    super.key,
    required this.chartData,
  });

  @override
  State<CustomPieChartCard> createState() => _CustomPieChartCardState();
}

class _CustomPieChartCardState extends State<CustomPieChartCard> {
  int? hoveredIndex;

  // ✅ ألوان مختلفة وواضحة
  static const _palette = [
    Color(0xFF6366F1), // indigo
    Color(0xFFF59E0B), // amber
    Color(0xFF10B981), // emerald
    Color(0xFFEF4444), // red
    Color(0xFF8B5CF6), // violet
  ];

  // ✅ حساب النسب من البيانات الحقيقية
  List<_Segment> get _segments {
    final total = widget.chartData
        .fold<int>(0, (sum, c) => sum + (c['studentCount'] as int));

    if (total == 0) return [];

    return List.generate(widget.chartData.length, (i) {
      final item = widget.chartData[i];
      return _Segment(
        label: item['teacherName'] as String,
        pct: (item['studentCount'] as int) / total,
        color: _palette[i % _palette.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final segments = _segments;

    // ✅ حالة فارغة
    if (segments.isEmpty) {
      return CustomCard(
        child: const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No chart data available',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate500,
              ),
            ),
          ),
        ),
      );
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Students per Teacher',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Row(
              children: [
                // ✅ حجم صريح للـ CustomPaint عشان يظهر
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = math.min(
                      constraints.maxWidth,
                      220.0,
                    );
                    return SizedBox(
                      width: size,
                      height: size,
                      child: CustomPaint(
                        painter: _PieChartPainter(
                          segments: segments,
                          hoveredIndex: hoveredIndex,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                // Legend
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < segments.length; i++) ...[
                        _LegendItem(segment: segments[i]),
                        if (i < segments.length - 1)
                          const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final _Segment segment;
  const _LegendItem({required this.segment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: segment.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '${segment.label} (${(segment.pct * 100).toStringAsFixed(0)}%)',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.slate600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Segment {
  final String label;
  final double pct;
  final Color color;
  const _Segment({
    required this.label,
    required this.pct,
    required this.color,
  });
}

class _PieChartPainter extends CustomPainter {
  final List<_Segment> segments;
  final int? hoveredIndex;

  _PieChartPainter({
    required this.segments,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.90;   // ✅ أكبر
    final innerR = r * 0.40;              // ✅ ثقب أصغر = slices أوضح

    final paint = Paint()..style = PaintingStyle.fill;
    final gapPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;                  // ✅ gap واضح بين الـ segments

    double angle = -math.pi / 2;

    // When there's only one segment (always 100%) — or, more generally,
    // any segment whose sweep is a full 2π — Path.arcTo can fail to draw
    // anything: the arc's start and end points are mathematically
    // identical, so the resulting path has zero effective area on some
    // renderers. Shrinking a full-circle sweep by a hair (an amount far
    // too small to be visible) keeps the start/end points distinct and
    // makes the slice render normally, without changing how it looks.
    const fullCircle = 2 * math.pi;
    const epsilon = 0.0001;

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      var sweep = seg.pct * fullCircle;
      if (sweep >= fullCircle - epsilon) {
        sweep = fullCircle - epsilon;
      }
      final isHovered = hoveredIndex == i;

      double dx = 0, dy = 0;
      if (isHovered) {
        final mid = angle + sweep / 2;
        dx = math.cos(mid) * 8;
        dy = math.sin(mid) * 8;
      }

      paint.color = seg.color;

      final path = Path()
        ..moveTo(
          cx + dx + innerR * math.cos(angle),
          cy + dy + innerR * math.sin(angle),
        );

      path.arcTo(
        Rect.fromCircle(center: Offset(cx + dx, cy + dy), radius: r),
        angle,
        sweep,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: Offset(cx + dx, cy + dy), radius: innerR),
        angle + sweep,
        -sweep,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);
      canvas.drawPath(path, gapPaint);

      // ✅ رسم النسبة المئوية على كل slice
      if (seg.pct > 0.08) {
        final mid = angle + sweep / 2;
        final labelR = innerR + (r - innerR) * 0.55;
        final lx = cx + dx + labelR * math.cos(mid);
        final ly = cy + dy + labelR * math.sin(mid);

        final tp = TextPainter(
          text: TextSpan(
            text: '${(seg.pct * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
      }

      angle += sweep;
    }

    // ✅ Center label
    final tp = TextPainter(
      text: const TextSpan(
        text: 'Teachers',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          color: AppColors.slate500,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter old) =>
      old.hoveredIndex != hoveredIndex || old.segments != segments;
}