import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/setting_cubit.dart';
import '../data/setting_repo.dart';
import '../data/settings_models.dart';
import 'settings_layout.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(SettingsRepository())..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}
class _SettingsViewState extends State<_SettingsView> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  bool _initialized  = false;
  SettingsLoaded? _lastLoaded;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _addressCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  void _initOnce(InstitutionProfile p) {
    if (_initialized) return;
    _nameCtrl.text    = p.name;
    _emailCtrl.text   = p.email;
    _addressCtrl.text = p.address;
    _phoneCtrl.text   = p.phone;
    _initialized = true;
  }

  InstitutionProfile _collect() => InstitutionProfile(
    name:    _nameCtrl.text,
    email:   _emailCtrl.text,
    address: _addressCtrl.text,
    phone:   _phoneCtrl.text,
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSaved) {
          _initialized = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Settings updated successfully ✅'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
        if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoaded) {
          _lastLoaded = state;
          _initOnce(state.profile);
        }

        if (state is SettingsLoading || state is SettingsInitial)
          return const Center(child: CircularProgressIndicator());

        if (state is SettingsError)
          return Center(child: Text(state.message,
              style: const TextStyle(color: AppColors.danger)));

        if (state is SettingsLoaded || state is SettingsSaving || state is SettingsSaved) {
          if (_lastLoaded == null) return const Center(child: CircularProgressIndicator());
          return SettingsLayout(
            state:       _lastLoaded!,
            nameCtrl:    _nameCtrl,
            emailCtrl:   _emailCtrl,
            addressCtrl: _addressCtrl,
            phoneCtrl:   _phoneCtrl,
            onSave: state is SettingsSaving
                ? () {}
                : () => context.read<SettingsCubit>().saveProfile(_collect()),
            isLoading: state is SettingsSaving,
          );
        }

        return const SizedBox();
      },
    );
  }



  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<SettingsCubit>().state;
    if (state is SettingsLoaded) _lastLoaded = state;
  }
}