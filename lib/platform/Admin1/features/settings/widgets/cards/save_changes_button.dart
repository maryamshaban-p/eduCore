import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class SaveChangesButton extends StatelessWidget {
  final VoidCallback onSave;
  final bool isLoading;

  const SaveChangesButton({
    super.key,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
            fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: isLoading
          ? const SizedBox(
              height: 18, width: 18,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : const Text('Save Changes'),
    );
  }
}