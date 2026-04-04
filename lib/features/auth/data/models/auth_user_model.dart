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
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
        createdAt,
        updatedAt,
      ];
}
