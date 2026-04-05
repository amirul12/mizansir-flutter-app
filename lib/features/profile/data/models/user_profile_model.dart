import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

/// User stats model for JSON serialization.
@JsonSerializable()
class UserStatsModel {
  @JsonKey(name: 'total_enrollments')
  final int totalEnrollments;
  @JsonKey(name: 'active_enrollments')
  final int activeEnrollments;
  @JsonKey(name: 'pending_enrollments')
  final int pendingEnrollments;

  UserStatsModel({
    required this.totalEnrollments,
    required this.activeEnrollments,
    required this.pendingEnrollments,
  });

  /// Create UserStatsModel from JSON.
  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  /// Convert UserStatsModel to JSON.
  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  /// Convert to UserStats entity.
  UserStats toEntity() {
    return UserStats(
      totalEnrollments: totalEnrollments,
      activeEnrollments: activeEnrollments,
      pendingEnrollments: pendingEnrollments,
    );
  }
}

/// Profile completion model for JSON serialization.
@JsonSerializable()
class ProfileCompletionModel {
  final int percentage;
  @JsonKey(name: 'completed_fields')
  final int completedFields;
  @JsonKey(name: 'total_fields')
  final int totalFields;
  @JsonKey(name: 'missing_fields')
  final List<String> missingFields;

  ProfileCompletionModel({
    required this.percentage,
    required this.completedFields,
    required this.totalFields,
    required this.missingFields,
  });

  /// Create ProfileCompletionModel from JSON.
  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileCompletionModelFromJson(json);

  /// Convert ProfileCompletionModel to JSON.
  Map<String, dynamic> toJson() => _$ProfileCompletionModelToJson(this);

  /// Convert to ProfileCompletion entity.
  ProfileCompletion toEntity() {
    return ProfileCompletion(
      percentage: percentage,
      completedFields: completedFields,
      totalFields: totalFields,
      missingFields: missingFields,
    );
  }
}

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
  final String? role;
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  @JsonKey(name: 'is_student')
  final bool isStudent;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final UserStatsModel? stats;
  final ProfileCompletionModel? profileCompletion;

  UserProfileModel({
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
    this.stats,
    this.profileCompletion,
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
      stats: stats?.toEntity(),
      profileCompletion: profileCompletion?.toEntity(),
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
      stats: entity.stats != null
          ? UserStatsModel(
              totalEnrollments: entity.stats!.totalEnrollments,
              activeEnrollments: entity.stats!.activeEnrollments,
              pendingEnrollments: entity.stats!.pendingEnrollments,
            )
          : null,
      profileCompletion: entity.profileCompletion != null
          ? ProfileCompletionModel(
              percentage: entity.profileCompletion!.percentage,
              completedFields: entity.profileCompletion!.completedFields,
              totalFields: entity.profileCompletion!.totalFields,
              missingFields: entity.profileCompletion!.missingFields,
            )
          : null,
    );
  }

  /// Create from API response wrapper.
  ///
  /// The API returns { data: { user: {...}, profile_completion: {...} } }
  factory UserProfileModel.fromApiResponse(Map<String, dynamic> responseData) {
    final userData = responseData['user'] as Map<String, dynamic>? ?? {};
    final profileCompletionData = responseData['profile_completion'] as Map<String, dynamic>?;

    // Add stats and profileCompletion to user data
    final userDataWithExtras = Map<String, dynamic>.from(userData);
    if (userData['stats'] != null) {
      userDataWithExtras['stats'] = userData['stats'];
    }
    if (profileCompletionData != null) {
      userDataWithExtras['profile_completion'] = profileCompletionData;
    }

    return UserProfileModel.fromJson(userDataWithExtras);
  }
}
