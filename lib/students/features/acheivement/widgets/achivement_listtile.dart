import 'package:edulink_app/students/features/home/widgets/statistic_circle.dart';
import 'package:flutter/material.dart';

class AchievementListTile extends StatelessWidget {
  const AchievementListTile({
    super.key,
    required this.title,
    required this.url,
    required this.subTitle,
    required this.percentage,
  });

  final String url, title, subTitle;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(
              url,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 60,
              height: 60,
              child: StatisticCircle(
                percentage: percentage,
                radius: 24,
                isHome: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}