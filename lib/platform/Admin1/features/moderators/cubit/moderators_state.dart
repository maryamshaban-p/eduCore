part of 'moderators_cubit.dart';

abstract class ModeratorsState {
  const ModeratorsState();
}

class ModeratorsInitial extends ModeratorsState {}

class ModeratorsLoading extends ModeratorsState {}

class ModeratorsLoaded extends ModeratorsState {
  final List<ModeratorModel> moderators;
  final List<TeacherModel> availableTeachers;
  final bool panelOpen;
  final ModeratorModel? selectedModerator;
  final bool isSubmitting;

  const ModeratorsLoaded({
    required this.moderators,
    required this.availableTeachers,
    this.panelOpen = false,
    this.selectedModerator,
    this.isSubmitting = false,
  });

  ModeratorsLoaded copyWith({
    List<ModeratorModel>? moderators,
    List<TeacherModel>? availableTeachers,
    bool? panelOpen,
    ModeratorModel? selectedModerator,
    bool clearSelected = false,
    bool? isSubmitting,
  }) {
    return ModeratorsLoaded(
      moderators: moderators ?? this.moderators,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      panelOpen: panelOpen ?? this.panelOpen,
      selectedModerator: clearSelected ? null : selectedModerator ?? this.selectedModerator,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ModeratorsError extends ModeratorsState {
  final String message;
  const ModeratorsError(this.message);
}

class ModeratorsSuccess extends ModeratorsState {
  final String message;
  const ModeratorsSuccess(this.message);
}