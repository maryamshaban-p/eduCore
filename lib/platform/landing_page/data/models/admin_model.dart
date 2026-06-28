
class AdminModel {
  final String token;
  final String id;
  final String firstname;
  final String lastname;
  final String email;

  AdminModel({
    required this.token,
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      token: json['token'],
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
    );
  }
}