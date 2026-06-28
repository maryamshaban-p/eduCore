import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title, buttonLabel;
  final VoidCallback onAdd;
  const SectionHeader({super.key, required this.title, required this.buttonLabel, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Breakpoints.isMobile(context)
        ? _MobileHeader(title: title, buttonLabel: buttonLabel, onAdd: onAdd)
        : _DesktopHeader(title: title, buttonLabel: buttonLabel, onAdd: onAdd);
  }
}

class _DesktopHeader extends StatelessWidget {
  final String title, buttonLabel;
  final VoidCallback onAdd;
  const _DesktopHeader({required this.title, required this.buttonLabel, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.slate900))),
      const SizedBox(width: 16),
      _AddButton(label: buttonLabel, onAdd: onAdd),
    ]);
  }
}

class _MobileHeader extends StatelessWidget {
  final String title, buttonLabel;
  final VoidCallback onAdd;
  const _MobileHeader({required this.title, required this.buttonLabel, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.slate900)),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: _AddButton(label: buttonLabel, onAdd: onAdd)),
    ]);
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onAdd;
  const _AddButton({required this.label, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isDark =  Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor:isDark? Theme.of(context).scaffoldBackgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
