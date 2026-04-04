// File: lib/features/auth/domain/entities/auth_user.dart
import 'package:equatable/equatable.dart';

/// Authenticated user entity
class AuthUser extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? collegeName;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
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

  /// Get initials for avatar placeholder
  String get initials {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  /// Check if user has complete profile
  bool get hasCompleteProfile {
    return phone != null &&
        phone!.isNotEmpty &&
        collegeName != null &&
        collegeName!.isNotEmpty;
  }

  /// Get display name
  String get displayName => name.trim();

  /// Get masked email for privacy
  String get maskedEmail {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 3) return email;
    final visible = username.substring(0, 3);
    final masked = '*' * (username.length - 3);
    return '$visible$masked@$domain';
  }
}
