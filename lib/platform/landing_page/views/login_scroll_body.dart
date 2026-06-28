import 'package:edulink_app/platform/landing_page/widgets/login_widgets/login_card.dart';
import 'package:edulink_app/platform/landing_page/widgets/login_widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScrollBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameCtrl, passwordCtrl;
  const LoginScrollBody({super.key, required this.formKey,
      required this.usernameCtrl, required this.passwordCtrl});

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFCBD5E1)),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(8),
        thickness: WidgetStateProperty.all(6),
      ),
      child: SingleChildScrollView(
        child: _LoginBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const LoginHeader(),
                const SizedBox(height: 32),
                LoginCard(formKey: formKey, usernameCtrl: usernameCtrl, passwordCtrl: passwordCtrl),
                const SizedBox(height: 64),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  final Widget child;
  const _LoginBackground({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A6E), Color(0xFF162D5A)]),
      ),
      child: Center(child: child),
    );
  }
}
