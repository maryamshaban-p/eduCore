part of 'teachers_cubit.dart';

abstract class TeachersState {
  const TeachersState();
}

class TeachersInitial extends TeachersState {}

class TeachersLoading extends TeachersState {}

class TeachersLoaded extends TeachersState {
  final List<TeacherModel> teachers;
  final bool panelOpen;
  final TeacherModel? selectedTeacher;
  final bool isSubmitting;

  const TeachersLoaded({
    required this.teachers,
    this.panelOpen = false,
    this.selectedTeacher,
    this.isSubmitting = false,
  });

  TeachersLoaded copyWith({
    List<TeacherModel>? teachers,
    bool? panelOpen,
    TeacherModel? selectedTeacher,
    bool clearSelected = false,
    bool? isSubmitting,
  }) {
    return TeachersLoaded(
      teachers: teachers ?? this.teachers,
      panelOpen: panelOpen ?? this.panelOpen,
      selectedTeacher: clearSelected ? null : selectedTeacher ?? this.selectedTeacher,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class TeachersError extends TeachersState {
  final String message;
  const TeachersError(this.message);
}

class TeachersSuccess extends TeachersState {
  final String message;
  const TeachersSuccess(this.message);
}