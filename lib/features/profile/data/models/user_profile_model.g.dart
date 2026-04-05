// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      totalEnrollments: (json['total_enrollments'] as num).toInt(),
      activeEnrollments: (json['active_enrollments'] as num).toInt(),
      pendingEnrollments: (json['pending_enrollments'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'total_enrollments': instance.totalEnrollments,
      'active_enrollments': instance.activeEnrollments,
      'pending_enrollments': instance.pendingEnrollments,
    };

ProfileCompletionModel _$ProfileCompletionModelFromJson(
  Map<String, dynamic> json,
) => ProfileCompletionModel(
  percentage: (json['percentage'] as num).toInt(),
  completedFields: (json['completed_fields'] as num).toInt(),
  totalFields: (json['total_fields'] as num).toInt(),
  missingFields: (json['missing_fields'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ProfileCompletionModelToJson(
  ProfileCompletionModel instance,
) => <String, dynamic>{
  'percentage': instance.percentage,
  'completed_fields': instance.completedFields,
  'total_fields': instance.totalFields,
  'missing_fields': instance.missingFields,
};

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar_url'] as String?,
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      isStudent: json['is_student'] as bool? ?? false,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      stats: json['stats'] == null
          ? null
          : UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      profileCompletion: json['profileCompletion'] == null
          ? null
          : ProfileCompletionModel.fromJson(
              json['profileCompletion'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatar,
      'college_name': instance.collegeName,
      'address': instance.address,
      'role': instance.role,
      'is_admin': instance.isAdmin,
      'is_student': instance.isStudent,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'stats': instance.stats,
      'profileCompletion': instance.profileCompletion,
    };
