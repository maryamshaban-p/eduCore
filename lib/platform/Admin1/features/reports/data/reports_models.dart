const List<int> kChartColors = [
  0xFF6366F1, 0xFF1E293B, 0xFF38BDF8,
  0xFF22C55E, 0xFFF59E0B, 0xFFEF4444,
];

class EnrollmentItem {
  final String label;
  final double count;
  const EnrollmentItem({required this.label, required this.count});

  factory EnrollmentItem.fromJson(Map<String, dynamic> json) {
    return EnrollmentItem(
      label: json['label'] as String? ?? '',
      count: (json['count'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TeacherShare {
  final String name;
  final double value;
  final int colorHex;
  const TeacherShare({required this.name, required this.value, required this.colorHex});

  factory TeacherShare.fromJson(Map<String, dynamic> json, int colorHex) {
    return TeacherShare(
      name:     json['name']  as String? ?? '',
      value:    (json['value'] as num?)?.toDouble() ?? 0,
      colorHex: colorHex,
    );
  }
}
