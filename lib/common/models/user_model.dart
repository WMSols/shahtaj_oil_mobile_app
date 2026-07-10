import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] ?? json['user_role'] ?? json['userRole'];

    return UserModel(
      id: (json['id'] ?? json['user_id'] ?? json['userId'])?.toString() ?? '',
      name:
          (json['name'] ??
                  json['full_name'] ??
                  json['fullName'] ??
                  json['user_name'] ??
                  json['username'])
              ?.toString()
              .trim() ??
          '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: UserRole.values.firstWhere(
        (r) => r.name == roleValue?.toString(),
        orElse: () => UserRole.orderBooker,
      ),
    );
  }

  UserModel withResolvedName() {
    if (name.trim().isNotEmpty) return this;

    final fromEmail = email.split('@').first.trim();
    if (fromEmail.isNotEmpty) {
      return UserModel(
        id: id,
        name: fromEmail,
        email: email,
        phone: phone,
        role: role,
      );
    }

    return this;
  }

  String displayName(String fallback) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return fallback;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.name,
  };
}
