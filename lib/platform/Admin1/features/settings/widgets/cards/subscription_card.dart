import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import '../../data/settings_models.dart';
import 'settings_card.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionInfo subscription;
  const SubscriptionCard({super.key, required this.subscription});

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Subscription',
      child: Row(children: [
        _SubItem(
          label: 'Plan',
          value: subscription.plan,
          valueStyle: const TextStyle(
              fontFamily: 'Inter', fontSize: 16,
              fontWeight: FontWeight.w700, color: AppColors.slate900),
        ),
        const SizedBox(width: 48),
        _SubItem(label: 'Expires', value: _formatDate(subscription.expiryDate)),
      ]),
    );
  }
}

class _SubItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  const _SubItem({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(
          fontFamily: 'Inter', fontSize: 13, color: AppColors.slate500)),
      const SizedBox(height: 4),
      Text(value, style: valueStyle ?? const TextStyle(
          fontFamily: 'Inter', fontSize: 16,
          fontWeight: FontWeight.w700, color: AppColors.slate900)),
    ]);
  }
}