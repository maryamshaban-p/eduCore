import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/settings_models.dart';
import '../data/setting_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repo;

  SettingsCubit(this._repo) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final profile      = await _repo.getProfile();
      final subscription = await _repo.getSubscription();
      emit(SettingsLoaded(profile: profile, subscription: subscription));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  Future<void> saveProfile(InstitutionProfile profile) async {
    emit(SettingsSaving());
    try {
      await _repo.saveProfile(profile);
      emit(SettingsSaved());
      await loadSettings();
    } catch (e) {
      emit(SettingsError('Failed to save settings: $e'));
    }
  }
}