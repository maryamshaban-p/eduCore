import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class MobileMenuButton extends StatelessWidget {
  final VoidCallback? onFeaturesTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onFaqTap;
  const MobileMenuButton({super.key, this.onFeaturesTap, this.onAboutTap, this.onFaqTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded, color: AppColors.slate700),
      onPressed: () => _show(context),
    );
  }

  void _show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _MobileMenuSheet(
        onFeaturesTap: () { Navigator.pop(context); onFeaturesTap?.call(); },
        onAboutTap:    () { Navigator.pop(context); onAboutTap?.call(); },
        onFaqTap:      () { Navigator.pop(context); onFaqTap?.call(); },
      ),
    );
  }
}

class _MobileMenuSheet extends StatelessWidget {
  final VoidCallback onFeaturesTap, onAboutTap, onFaqTap;
  const _MobileMenuSheet({required this.onFeaturesTap, required this.onAboutTap, required this.onFaqTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _MenuItem(label: 'Features',   onTap: onFeaturesTap),
        _MenuItem(label: 'About',      onTap: onAboutTap),
        _MenuItem(label: 'Contact Us', onTap: onFaqTap),
      ]),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MenuItem({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 16,
          fontWeight: FontWeight.w500, color: AppColors.slate700)),
      onTap: onTap,
    );
  }
}
