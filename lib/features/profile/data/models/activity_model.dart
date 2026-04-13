import '../../domain/entities/activity.dart';

/// Activity type converter for JSON serialization.
class ActivityTypeConverter {
  static ActivityType fromJson(String type) {
    switch (type) {
      case 'lesson_completed':
        return ActivityType.lessonCompleted;
      case 'enrollment':
      case 'enrollment_created':
        return ActivityType.enrollmentCreated;
      case 'course_progress_updated':
        return ActivityType.courseProgressUpdated;
      case 'profile_updated':
        return ActivityType.profileUpdated;
      case 'password_changed':
        return ActivityType.passwordChanged;
      case 'avatar_updated':
        return ActivityType.avatarUpdated;
      case 'account_deleted':
        return ActivityType.accountDeleted;
      default:
        // Default to a safe type if unknown
        return ActivityType.profileUpdated;
    }
  }

  static String toJson(ActivityType type) {
    switch (type) {
      case ActivityType.lessonCompleted:
        return 'lesson_completed';
      case ActivityType.enrollmentCreated:
        return 'enrollment_created';
      case ActivityType.courseProgressUpdated:
        return 'course_progress_updated';
      case ActivityType.profileUpdated:
        return 'profile_updated';
      case ActivityType.passwordChanged:
        return 'password_changed';
      case ActivityType.avatarUpdated:
        return 'avatar_updated';
      case ActivityType.accountDeleted:
        return 'account_deleted';
    }
  }
}

/// Activity model for JSON serialization.
class ActivityModel {
  final int id;
  final int userId;
  final String type;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.metadata,
    required this.createdAt,
  });

  /// Create ActivityModel from JSON.
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as String? ?? 'unknown',
      description: json['description'] as String? ?? '',
      metadata: json['course'] != null 
          ? {'course': json['course']} 
          : json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert ActivityModel to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'description': description,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert to Activity entity.
  Activity toEntity() {
    return Activity(
      id: id,
      userId: userId,
      type: ActivityTypeConverter.fromJson(type),
      description: description,
      metadata: metadata,
      createdAt: createdAt,
    );
  }

  /// Create ActivityModel from Activity entity.
  factory ActivityModel.fromEntity(Activity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      type: ActivityTypeConverter.toJson(entity.type),
      description: entity.description,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
    );
  }
}
