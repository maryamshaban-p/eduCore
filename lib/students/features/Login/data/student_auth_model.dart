class StudentAuthModel {
  final String token;
  final String username;
  final String fullName;

  StudentAuthModel({
    required this.token,
    required this.username,
    required this.fullName,
  });

  factory StudentAuthModel.fromJson(Map<String, dynamic> json) {
    return StudentAuthModel(
      token:    json['token']    as String? ?? '',
      username: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }
}