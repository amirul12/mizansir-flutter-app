import 'package:equatable/equatable.dart';

/// My Course Entity for nested API response structure
class MyCourseEntity extends Equatable {
  final String id;
  final CourseInfo course;
  final CurriculumInfo curriculum;
  final EnrollmentInfo enrollment;

  const MyCourseEntity({
    required this.id,
    required this.course,
    required this.curriculum,
    required this.enrollment,
  });

  @override
  List<Object?> get props => [id, course, curriculum, enrollment];
}

/// Course basic information
class CourseInfo extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final String price;
  final String formattedPrice;
  final String status;
  final String difficultyLevel;
  final int totalDurationMinutes;
  final String formattedDuration;

  const CourseInfo({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.price,
    required this.formattedPrice,
    required this.status,
    required this.difficultyLevel,
    required this.totalDurationMinutes,
    required this.formattedDuration,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnail,
        price,
        formattedPrice,
        status,
        difficultyLevel,
        totalDurationMinutes,
        formattedDuration,
      ];
}

/// Curriculum and progress information
class CurriculumInfo extends Equatable {
  final int totalLessons;
  final int completedLessons;
  final int remainingLessons;
  final double progressPercentage;
  final int modulesCount;
  final List<ModuleInfo> modules;
  final NextLessonInfo? nextLesson;

  const CurriculumInfo({
    required this.totalLessons,
    required this.completedLessons,
    required this.remainingLessons,
    required this.progressPercentage,
    required this.modulesCount,
    required this.modules,
    this.nextLesson,
  });

  @override
  List<Object?> get props => [
        totalLessons,
        completedLessons,
        remainingLessons,
        progressPercentage,
        modulesCount,
        modules,
        nextLesson,
      ];
}

/// Module information
class ModuleInfo extends Equatable {
  final String moduleName;
  final int lessonsCount;
  final int durationMinutes;

  const ModuleInfo({
    required this.moduleName,
    required this.lessonsCount,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [moduleName, lessonsCount, durationMinutes];
}

/// Next lesson information
class NextLessonInfo extends Equatable {
  final String id;
  final String title;
  final int? durationMinutes;
  final String moduleName;

  const NextLessonInfo({
    required this.id,
    required this.title,
    this.durationMinutes,
    required this.moduleName,
  });

  @override
  List<Object?> get props => [id, title, durationMinutes, moduleName];
}

/// Enrollment information
class EnrollmentInfo extends Equatable {
  final String id;
  final String status;
  final String paymentMethod;
  final String paymentNotes;
  final DateTime enrolledAt;
  final DateTime approvedAt;
  final DateTime expiresAt;
  final bool isActive;
  final int daysRemaining;
  final int enrollmentDurationDays;

  const EnrollmentInfo({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.paymentNotes,
    required this.enrolledAt,
    required this.approvedAt,
    required this.expiresAt,
    required this.isActive,
    required this.daysRemaining,
    required this.enrollmentDurationDays,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        paymentMethod,
        paymentNotes,
        enrolledAt,
        approvedAt,
        expiresAt,
        isActive,
        daysRemaining,
        enrollmentDurationDays,
      ];
}
