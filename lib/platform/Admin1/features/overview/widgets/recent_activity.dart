import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/features/overview/data/models/adminOverview_model.dart';
import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  final List<ActivityItem> items;
  const RecentActivity({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Recent Activity',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate800)),
        const SizedBox(height: 16),
        ...items.map((item) => _ActivityTile(item: item)),
      ]),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem item;
  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8, height: 8,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.text,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate700, height: 1.4)),
            const SizedBox(height: 3),
            Text(item.time,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
          ]),
        ),
      ]),
    );
  }
}
