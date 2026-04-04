import 'package:equatable/equatable.dart';

/// Activity types representing different user actions.
enum ActivityType {
  lessonCompleted,
  enrollmentCreated,
  courseProgressUpdated,
  profileUpdated,
  passwordChanged,
  avatarUpdated,
  accountDeleted,
}

/// Activity entity representing a user activity/event.
class Activity extends Equatable {
  final int id;
  final int userId;
  final ActivityType type;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const Activity({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.metadata,
    required this.createdAt,
  });

  /// Returns true if activity is course-related.
  bool get isCourseRelated =>
      type == ActivityType.lessonCompleted ||
      type == ActivityType.enrollmentCreated ||
      type == ActivityType.courseProgressUpdated;

  /// Returns true if activity is profile-related.
  bool get isProfileRelated =>
      type == ActivityType.profileUpdated ||
      type == ActivityType.passwordChanged ||
      type == ActivityType.avatarUpdated;

  /// Returns activity type label for display.
  String get typeLabel {
    switch (type) {
      case ActivityType.lessonCompleted:
        return 'Lesson Completed';
      case ActivityType.enrollmentCreated:
        return 'Course Enrolled';
      case ActivityType.courseProgressUpdated:
        return 'Progress Updated';
      case ActivityType.profileUpdated:
        return 'Profile Updated';
      case ActivityType.passwordChanged:
        return 'Password Changed';
      case ActivityType.avatarUpdated:
        return 'Avatar Updated';
      case ActivityType.accountDeleted:
        return 'Account Deleted';
    }
  }

  /// Returns activity icon name based on type.
  String get iconName {
    switch (type) {
      case ActivityType.lessonCompleted:
        return 'check_circle';
      case ActivityType.enrollmentCreated:
        return 'school';
      case ActivityType.courseProgressUpdated:
        return 'trending_up';
      case ActivityType.profileUpdated:
        return 'person';
      case ActivityType.passwordChanged:
        return 'lock';
      case ActivityType.avatarUpdated:
        return 'photo_camera';
      case ActivityType.accountDeleted:
        return 'delete_forever';
    }
  }

  @override
  List<Object?> get props => [id, userId, type, description, metadata, createdAt];
}
