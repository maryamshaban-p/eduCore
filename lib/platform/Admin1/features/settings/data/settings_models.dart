class InstitutionProfile {
  final String name;
  final String email;
  final String address;
  final String phone;

  const InstitutionProfile({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });

  factory InstitutionProfile.fromJson(Map<String, dynamic> json) {
    return InstitutionProfile(
      name:    json['institutionName'] as String? ?? '',
      email:   json['contactEmail']    as String? ?? '',
      address: json['address']         as String? ?? '',
      phone:   json['phone']           as String? ?? '',
    );
  }
}

class SubscriptionInfo {
  final String plan;
  final String expiryDate;

  const SubscriptionInfo({required this.plan, required this.expiryDate});

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    final sub = json['subscription'] as Map<String, dynamic>? ?? {};
    return SubscriptionInfo(
      plan:       sub['plan']    as String? ?? '',
      expiryDate: sub['expires'] as String? ?? '',
    );
  }
}