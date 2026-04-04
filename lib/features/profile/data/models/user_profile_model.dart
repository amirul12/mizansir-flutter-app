import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

/// User profile model for JSON serialization.
@JsonSerializable()
class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatar;
  @JsonKey(name: 'college_name')
  final String? collegeName;
  final String? address;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  UserProfileModel({
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

  /// Create UserProfileModel from JSON.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert UserProfileModel to JSON.
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// Convert to UserProfile entity.
  UserProfile toEntity() {
    return UserProfile(
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

  /// Create UserProfileModel from UserProfile entity.
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
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
}
