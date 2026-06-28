import 'package:flutter/material.dart';

class StatisticsListTile extends StatelessWidget {
  const StatisticsListTile({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.supTitle,
  });

  final Color color;
  final IconData icon;
  final String title, supTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Color(0xFFA5AAB5)),
              ),
              Text(
                supTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
