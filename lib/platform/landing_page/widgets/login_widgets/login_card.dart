import 'package:edulink_app/platform/landing_page/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'card/role_section.dart';
import 'login_button.dart';
import 'login_form_fields.dart';

const _usernameHints = [
  'admin@institution.com',
  'moderator@example.com',
  'teacher@example.com',
];

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameCtrl, passwordCtrl;

  const LoginCard({
    super.key,
    required this.formKey,
    required this.usernameCtrl,
    required this.passwordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (prev, curr) =>
          curr.loginSuccess != prev.loginSuccess ||
          curr.loggedInRole != prev.loggedInRole,
      listener: (context, state) {
        if (!state.loginSuccess) return;
        // Navigate based on role returned by the server
        switch (state.loggedInRole) {
          case 'Admin':
            Navigator.of(context).pushReplacementNamed('/admin');
          case 'Moderator':
            Navigator.of(context).pushReplacementNamed('/moderator');
          case 'Teacher':
            Navigator.of(context).pushReplacementNamed('/teacher');
            
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: formKey,
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RoleSection(),
                  const SizedBox(height: 20),
                  UsernameField(
                    ctrl: usernameCtrl,
                    hint: _usernameHints[state.selectedRole],
                  ),
                  const SizedBox(height: 14),
                  PasswordField(
                    ctrl: passwordCtrl,
                    obscure: state.obscurePassword,
                    onToggle: cubit.togglePassword,
                  ),

                  // ── Error message ──────────────────────────────────────
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 14),
                    _ErrorBanner(message: state.errorMessage!),
                  ],

                  const SizedBox(height: 28),
                  LoginButton(
                    isLoading: state.isLoading,
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      cubit.submit(
  email: usernameCtrl.text,
  password: passwordCtrl.text,
  context: context,
);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}