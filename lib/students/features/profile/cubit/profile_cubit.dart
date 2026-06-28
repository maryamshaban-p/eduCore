import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_model.dart';
import '../data/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  ProfileModel? _currentProfile;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _repo.getProfile();
      _currentProfile = profile;
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String languagePref,
  }) async {
    if (_currentProfile == null) return;
    emit(ProfileSaving(_currentProfile!));
    try {
      await _repo.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        languagePref: languagePref,
      );
      final updated = await _repo.getProfile();
      _currentProfile = updated;
      emit(ProfileSaved(updated));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> uploadPhoto(Uint8List bytes, String fileName) async {
    if (_currentProfile == null) return;
    emit(ProfilePhotoUploading(_currentProfile!));
    try {
      await _repo.uploadPhoto(bytes, fileName);
      final updated = await _repo.getProfile();
      _currentProfile = updated;
      emit(ProfileSaved(updated));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deletePhoto() async {
    if (_currentProfile == null) return;
    emit(ProfilePhotoUploading(_currentProfile!));
    try {
      await _repo.deletePhoto();
      final updated = await _repo.getProfile();
      _currentProfile = updated;
      emit(ProfileSaved(updated));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _repo.logout();
  }
}