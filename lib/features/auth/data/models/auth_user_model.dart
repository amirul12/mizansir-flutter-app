// File: lib/features/auth/data/models/auth_user_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

/// Auth user model for JSON serialization
class AuthUserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? collegeName;
  final String? address;
  final String? role;
  final bool isAdmin;
  final bool isStudent;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.collegeName,
    this.address,
    this.role,
    this.isAdmin = false,
    this.isStudent = false,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
      collegeName: json['college_name']?.toString(),
      address: json['address']?.toString(),
      role: json['role']?.toString(),
      isAdmin: json['is_admin'] is bool ? json['is_admin'] as bool : false,
      isStudent: json['is_student'] is bool ? json['is_student'] as bool : false,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String? ?? json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String? ?? json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'college_name': collegeName,
      'address': address,
      'role': role,
      'is_admin': isAdmin,
      'is_student': isStudent,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert to entity
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      collegeName: collegeName,
      address: address,
      role: role,
      isAdmin: isAdmin,
      isStudent: isStudent,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert from entity
  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatar: entity.avatar,
      collegeName: entity.collegeName,
      address: entity.address,
      role: entity.role,
      isAdmin: entity.isAdmin,
      isStudent: entity.isStudent,
      emailVerifiedAt: entity.emailVerifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatar,
        collegeName,
        address,
        role,
        isAdmin,
        isStudent,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
