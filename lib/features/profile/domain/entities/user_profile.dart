import 'package:equatable/equatable.dart';

/// User profile entity containing user information and settings.
class UserProfile extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? collegeName;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
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

  /// Returns true if user has uploaded an avatar.
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  /// Returns true if user has provided phone number.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  /// Returns true if user has provided college name.
  bool get hasCollegeName => collegeName != null && collegeName!.isNotEmpty;

  /// Returns true if user has provided address.
  bool get hasAddress => address != null && address!.isNotEmpty;

  /// Returns true if profile is complete (has all optional fields).
  bool get isComplete => hasPhone && hasCollegeName && hasAddress && hasAvatar;

  /// Returns initials from name (e.g., "John Doe" -> "JD").
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  /// Returns masked email (e.g., "j***@example.com").
  String get maskedEmail {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 1) return email;

    return '${username[0]}${'*' * (username.length - 1)}@$domain';
  }

  /// Returns display name (returns name if available, else email).
  String get displayName => name.trim().isEmpty ? email : name.trim();

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

  /// CopyWith method for creating modified copies.
  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? collegeName,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      collegeName: collegeName ?? this.collegeName,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
