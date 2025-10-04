import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final DateTime createdAt;
  final String role;
  final String? department;
  bool isVerified;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.role,
    required this.department,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'isVerified': isVerified,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
      'department': department,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      isVerified: map['isVerified'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['createdAt']),
      role: map['role'],
      department: map['department'],
    );
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    bool? isVerified,
    String? role,
    String? department,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      role: role ?? this.role,
      department: department ?? this.department,
      isVerified: isVerified ?? this.isVerified,
    );
  }


  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
