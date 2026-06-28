import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class NavLogo extends StatelessWidget {
  const NavLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
              color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.school_outlined, color: Colors.white, size: 28),
        ),
      ]),
    );
  }
}
