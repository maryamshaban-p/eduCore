import 'package:edulink_app/platform/landing_page/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/logout_cubit.dart';
import 'dialog/logout_actions.dart';
import 'dialog/logout_content.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context, barrierDismissible: true,
      builder: (_) => BlocProvider(create: (_) => LogoutCubit(), child: const LogoutDialog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return BlocListener<LogoutCubit, LogoutState>(
      listener: _onStateChanged,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: w < 500 ? w * 0.9 : 380),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const LogoutDialogContent(),
              const SizedBox(height: 28),
              LogoutActions(),
            ]),
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LogoutState state) {
    if (state is LogoutSuccess) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingPage()), (route) => false,
      );
    }
  }
}
