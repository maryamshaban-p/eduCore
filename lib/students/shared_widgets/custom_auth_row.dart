import 'package:edulink_app/students/shared_widgets/custom_icon.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:flutter/material.dart';

class CustomAuthRow extends StatelessWidget {
  const CustomAuthRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIcon(
          iconName: AppImages.googleIcon,
        ),
        SizedBox(
          width: 30,
        ),
        CustomIcon(
          iconName: AppImages.facebookIcon,
        ),
        SizedBox(
          width: 30,
        ),
        CustomIcon(
          iconName: AppImages.appleIcon,
        ),
      ],
    );
  }
}
