import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StudentActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> activityData;

  const StudentActivityChart({
    super.key,
    required this.activityData,
  });

  List<dynamic> _parseData() {
    if (activityData.isEmpty) return [];
    return activityData.map((e) => (e['count'] ?? 0).toDouble()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _parseData();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Student Activity — Past 30 Days',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 16),
          if (chartData.isEmpty)
            const SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_outlined,
                        size: 40, color: AppColors.slate300),
                    SizedBox(height: 8),
                    Text(
                      'No activity yet',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.slate400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: _LineChartPainter(data: chartData),
              ),
            ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<dynamic> data;
  const _LineChartPainter({required this.data});

  static const double _padL = 40, _padR = 16, _padT = 12, _padB = 36;
  static const double _minVal = 0, _maxVal = 60;
  static const _yLabels = [0, 15, 30, 45, 60];
  static const _xLabelIndices = [0, 5, 10, 15, 20, 25];

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final cW = size.width - _padL - _padR;
    final cH = size.height - _padT - _padB;

    final gridPaint = Paint()
      ..color = AppColors.slate200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Grid + Y labels
    for (final yVal in _yLabels) {
      final y = _padT + cH * (1 - (yVal - _minVal) / (_maxVal - _minVal));
      _drawDashed(canvas, Offset(_padL, y),
          Offset(size.width - _padR, y), gridPaint);
      _drawText(canvas, '$yVal', Offset(0, y - 7),
          width: _padL - 6, align: TextAlign.right);
    }

    // X labels
    for (final idx in _xLabelIndices) {
      if (idx >= data.length) continue;
      final x = _padL + (idx / (data.length - 1)) * cW;
      _drawText(canvas, 'D${idx + 1}',
          Offset(x - 16, size.height - _padB + 8),
          width: 32, align: TextAlign.center);
    }

    // Gradient fill
    final fillPath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = _padL + (i / (data.length - 1)) * cW;
      final y = _padT +
          cH * (1 - (data[i] - _minVal) / (_maxVal - _minVal));
      if (i == 0) {
        fillPath.moveTo(x, y);
      } else {
        final px = _padL + ((i - 1) / (data.length - 1)) * cW;
        final py = _padT +
            cH * (1 - (data[i - 1] - _minVal) / (_maxVal - _minVal));
        final cpX = (px + x) / 2;
        fillPath.cubicTo(cpX, py, cpX, y, x, y);
      }
    }
    final lastX = _padL + cW;
    fillPath.lineTo(lastX, _padT + cH);
    fillPath.lineTo(_padL, _padT + cH);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.15),
          AppColors.primary.withOpacity(0.0)
        ],
      ).createShader(Rect.fromLTWH(_padL, _padT, cW, cH));
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = _padL + (i / (data.length - 1)) * cW;
      final y = _padT +
          cH * (1 - (data[i] - _minVal) / (_maxVal - _minVal));
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        final px = _padL + ((i - 1) / (data.length - 1)) * cW;
        final py = _padT +
            cH * (1 - (data[i - 1] - _minVal) / (_maxVal - _minVal));
        final cpX = (px + x) / 2;
        linePath.cubicTo(cpX, py, cpX, y, x, y);
      }
    }
    canvas.drawPath(linePath, linePaint);
  }

  void _drawDashed(
      Canvas canvas, Offset start, Offset end, Paint paint) {
    const dw = 5.0, ds = 4.0;
    final dx = end.dx - start.dx, dy = end.dy - start.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    double drawn = 0;
    while (drawn < dist) {
      final s2 = math.min(drawn + dw, dist);
      canvas.drawLine(
        Offset(start.dx + dx * drawn / dist,
            start.dy + dy * drawn / dist),
        Offset(start.dx + dx * s2 / dist,
            start.dy + dy * s2 / dist),
        paint,
      );
      drawn += dw + ds;
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset,
      {double width = 40, TextAlign align = TextAlign.left}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.slate400),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout(maxWidth: width);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.data != data;
}