class ModeratorModel {
  final String id;
  final String moderatorId;
  final String firstname;
  final String lastname;
  final String email;
  final int studentsManaged;
  final String lastActive;
  final List<String> assignedTeacherIds;

  const ModeratorModel({
    required this.id,
    required this.moderatorId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.studentsManaged,
    required this.lastActive,
    required this.assignedTeacherIds,
  });

  String get name => '$firstname $lastname';

  factory ModeratorModel.fromJson(Map<String, dynamic> json) {
    return ModeratorModel(
      id: json['id'] ?? '',
      moderatorId: json['moderator_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      studentsManaged: json['students_managed'] ?? 0,
      lastActive: json['last_active'] ?? '',
      assignedTeacherIds: List<String>.from(
        (json['assigned_teacher_ids'] ?? []).map((e) => e.toString()),
      ),
    );
  }
}