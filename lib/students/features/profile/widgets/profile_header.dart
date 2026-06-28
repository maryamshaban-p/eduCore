import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ProfileHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenWidth * 0.12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "My Profile".tr(),
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        /*  Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                size: screenWidth * 0.055,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: onBack,
            ),
          ),*/
        ],
      ),
    );
  }
}