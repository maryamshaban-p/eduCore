import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class PanelSubmitButton extends StatelessWidget {
  final bool isEdit;
  final bool isLoading;
  final VoidCallback onPressed;

  const PanelSubmitButton({
    super.key,
    required this.isEdit,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                isEdit ? 'Save Changes' : 'Create Account',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}