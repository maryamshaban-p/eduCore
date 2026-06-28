import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/logout_cubit.dart';

class LogoutActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutCubit, LogoutState>(
      builder: (context, state) {
        final loading = state is LogoutLoading;
        return Row(children: [
          Expanded(child: _CancelButton(isLoading: loading)),
          const SizedBox(width: 12),
          Expanded(child: _ConfirmButton(isLoading: loading)),
        ]);
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  final bool isLoading;
  const _CancelButton({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.slate600,
        side: const BorderSide(color: AppColors.slate200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: const Text('Cancel'),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final bool isLoading;
  const _ConfirmButton({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => context.read<LogoutCubit>().logout(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger, foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: isLoading
          ? const SizedBox(width: 18, height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Text('Logout'),
    );
  }
}