class TeacherModel {
  final String id;
  final String teacherId;
  final String firstname;
  final String lastname;
  final String email;
  final String subject;
  final int courseCount;
  final int studentsCount;

  const TeacherModel({
    required this.id,
    required this.teacherId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.subject,
    required this.courseCount,
    required this.studentsCount,
  });

  String get name => '$firstname $lastname';

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] ?? '',
      teacherId: json['teacherId'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      courseCount: json['courseCount'] ?? 0,
      studentsCount: json['studentsCount'] ?? 0,
    );
  }
}