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
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role']?.toString(),
        orElse: () => UserRole.orderBooker,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.name,
  };
}
