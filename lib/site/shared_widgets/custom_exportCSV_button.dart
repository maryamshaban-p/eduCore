import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class CustomExportCsvButton extends StatefulWidget {
  final double? screenWidth;
  final double? screenHeight;
  final VoidCallback? onTap;

  const CustomExportCsvButton({
    super.key,
    this.screenWidth,
    this.screenHeight,
    this.onTap,
  });

  @override
  State<CustomExportCsvButton> createState() => _CustomExportCsvButtonState();
}

class _CustomExportCsvButtonState extends State<CustomExportCsvButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.slate50 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              const Text(
                'Export CSV',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
