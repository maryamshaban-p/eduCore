import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'login_input.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  const UsernameField({super.key, required this.ctrl, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const LoginLabel('Username'),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate800),
        decoration: loginInputDeco(hint: hint),
        validator: (v) => (v == null || v.isEmpty) ? 'Username is required' : null,
      ),
    ]);
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool obscure;
  final VoidCallback onToggle;
  const PasswordField({super.key, required this.ctrl, required this.obscure, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const LoginLabel('Password'),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate800),
        decoration: loginInputDeco(
          hint: '••••••••',
          suffix: IconButton(
            icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.slate400, size: 20),
            onPressed: onToggle,
          ),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Password is required';
          if (v.length < 6) return 'At least 6 characters';
          return null;
        },
      ),
    ]);
  }
}
