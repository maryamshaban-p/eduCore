part of 'profile_cubit.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  const ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileSaving extends ProfileState {
  final ProfileModel profile;
  const ProfileSaving(this.profile);
}

class ProfileSaved extends ProfileState {
  final ProfileModel profile;
  const ProfileSaved(this.profile);
}

class ProfilePhotoUploading extends ProfileState {
  final ProfileModel profile;
  const ProfilePhotoUploading(this.profile);
}