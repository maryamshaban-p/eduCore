// lib/students/features/requests/data/request_model.dart

class StudentRequest {
  final String id;
  final String sessionTitle;
  final String type; // "views" or "test"
  final String reason;
  final String status; // "Pending", "Approved", "Rejected"
  final DateTime createdAt;

  StudentRequest({
    required this.id,
    required this.sessionTitle,
    required this.type,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory StudentRequest.fromJson(Map<String, dynamic> json) {
    return StudentRequest(
      id: json['id'] as String? ?? '',
      sessionTitle: json['sessionTitle'] as String? ?? '',
      type: json['type'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}