class ProfileModel {
  final String userId;
  final String studentId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String languagePref;
  final String academicLevel;
  final String classLevel;
  final String parentPhoneNumber;
  final String? imageUrl;
  final String avatarInitials;

  ProfileModel({
    required this.userId,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.languagePref,
    required this.academicLevel,
    required this.classLevel,
    required this.parentPhoneNumber,
    this.imageUrl,
    required this.avatarInitials,
  });

  String get fullName => '$firstName $lastName';

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      languagePref: json['languagePref'] as String? ?? '',
      academicLevel: json['academicLevel'] as String? ?? '',
      classLevel: json['classLevel'] as String? ?? '',
      parentPhoneNumber: json['parentPhoneNumber'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      avatarInitials: json['avatarInitials'] as String? ?? '',
    );
  }
}