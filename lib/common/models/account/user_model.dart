import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.orderBookerId,
    this.presenceStatus = PresenceStatus.away,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? orderBookerId;
  final PresenceStatus presenceStatus;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] ?? json['user_role'] ?? json['userRole'];
    final login = json['login']?.toString();

    return UserModel(
      id: (json['id'] ?? json['user_id'] ?? json['userId'])?.toString() ?? '',
      name:
          (json['name'] ??
                  json['full_name'] ??
                  json['fullName'] ??
                  json['user_name'] ??
                  json['username'] ??
                  login)
              ?.toString()
              .trim() ??
          '',
      email: (json['email'] ?? login)?.toString() ?? '',
      phone: json['phone']?.toString(),
      orderBookerId: (json['order_booker_id'] ?? json['orderBookerId'])
          ?.toString(),
      role: UserRole.values.firstWhere(
        (r) => r.name == roleValue?.toString(),
        orElse: () => UserRole.orderBooker,
      ),
      presenceStatus: PresenceStatusX.fromApi(
        json['online_status'] ?? json['presence_status'] ?? json['presence'],
      ),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? orderBookerId,
    PresenceStatus? presenceStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      orderBookerId: orderBookerId ?? this.orderBookerId,
      presenceStatus: presenceStatus ?? this.presenceStatus,
    );
  }

  UserModel withResolvedName() {
    if (name.trim().isNotEmpty) return this;

    final fromEmail = email.split('@').first.trim();
    if (fromEmail.isNotEmpty) {
      return copyWith(name: fromEmail);
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
    'order_booker_id': orderBookerId,
    'online_status': presenceStatus.name,
  };
}
