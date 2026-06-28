import 'package:flutter/material.dart';
import '../cubit/setting_cubit.dart';
import 'cards/profile_card.dart';
import 'cards/subscription_card.dart';

class SettingsLayout extends StatelessWidget {
  final SettingsLoaded state;
  final TextEditingController nameCtrl, emailCtrl, addressCtrl, phoneCtrl;
  final VoidCallback onSave;
  final bool isLoading;

  const SettingsLayout({
    super.key,
    required this.state,
    required this.nameCtrl,    required this.emailCtrl,
    required this.addressCtrl, required this.phoneCtrl,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        ProfileCard(
          nameCtrl:    nameCtrl,
          emailCtrl:   emailCtrl,
          addressCtrl: addressCtrl,
          phoneCtrl:   phoneCtrl,
          onSave:      onSave,
          isLoading:   isLoading,
        ),
        const SizedBox(height: 24),
        SubscriptionCard(subscription: state.subscription),
      ]),
    );
  }
}