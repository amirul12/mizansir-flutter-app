import '../../domain/entities/user_profile.dart';

/// User stats model for manual parsing.
class UserStatsModel {
  final int totalEnrollments;
  final int activeEnrollments;
  final int pendingEnrollments;

  UserStatsModel({
    required this.totalEnrollments,
    required this.activeEnrollments,
    required this.pendingEnrollments,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalEnrollments: json['total_enrollments'] as int? ?? 0,
      activeEnrollments: json['active_enrollments'] as int? ?? 0,
      pendingEnrollments: json['pending_enrollments'] as int? ?? 0,
    );
  }

  UserStats toEntity() {
    return UserStats(
      totalEnrollments: totalEnrollments,
      activeEnrollments: activeEnrollments,
      pendingEnrollments: pendingEnrollments,
    );
  }
}

/// Profile completion model for manual parsing.
class ProfileCompletionModel {
  final int percentage;
  final int completedFields;
  final int totalFields;
  final List<String> missingFields;

  ProfileCompletionModel({
    required this.percentage,
    required this.completedFields,
    required this.totalFields,
    required this.missingFields,
  });

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionModel(
      percentage: json['percentage'] as int? ?? 0,
      completedFields: json['completed_fields'] as int? ?? 0,
      totalFields: json['total_fields'] as int? ?? 0,
      missingFields: (json['missing_fields'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  ProfileCompletion toEntity() {
    return ProfileCompletion(
      percentage: percentage,
      completedFields: completedFields,
      totalFields: totalFields,
      missingFields: missingFields,
    );
  }
}

/// User profile model for manual parsing.
class UserProfileModel {
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar_url'] as String? ?? json['avatar'] as String?,
      collegeName: json['college_name'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      isStudent: json['is_student'] as bool? ?? true,
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.tryParse(json['email_verified_at'].toString()) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      stats: json['stats'] != null ? UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>) : null,
      profileCompletion: json['profile_completion'] != null 
          ? ProfileCompletionModel.fromJson(json['profile_completion'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Create from API response wrapper.
  ///
  /// The API returns { data: { user: {...}, profile_completion: {...} } }
  factory UserProfileModel.fromApiResponse(Map<String, dynamic> responseData) {
    final userData = responseData['user'] as Map<String, dynamic>? ?? {};
    final profileCompletionData = responseData['profile_completion'] as Map<String, dynamic>?;

    final userDataWithExtras = Map<String, dynamic>.from(userData);
    
    // If stats is not already in userData but is somewhere else in responseData, 
    // we could add it, but based on user example it is inside user.
    
    if (profileCompletionData != null) {
      userDataWithExtras['profile_completion'] = profileCompletionData;
    }

    return UserProfileModel.fromJson(userDataWithExtras);
  }

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
}
