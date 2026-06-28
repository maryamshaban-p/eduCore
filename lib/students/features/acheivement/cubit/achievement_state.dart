part of 'achievement_cubit.dart';

abstract class AchievementState {
  const AchievementState();
}

class AchievementInitial extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementLoaded extends AchievementState {
  final AchievementModel data;
  const AchievementLoaded(this.data);
}

class AchievementError extends AchievementState {
  final String message;
  const AchievementError(this.message);
}