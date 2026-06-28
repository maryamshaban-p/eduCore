part of 'setting_cubit.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial  extends SettingsState {}
class SettingsLoading  extends SettingsState {}
class SettingsSaving   extends SettingsState {}
class SettingsSaved    extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final InstitutionProfile profile;
  final SubscriptionInfo subscription;

  const SettingsLoaded({required this.profile, required this.subscription});
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}
