import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/my_course_entity.dart';

part 'my_course_model.g.dart';

/// Model for My Courses API response
@JsonSerializable()
class MyCourseModel {
  final int id;
  @JsonKey(name: 'course')
  final CourseInfoModel course;
  @JsonKey(name: 'curriculum')
  final CurriculumInfoModel curriculum;
  @JsonKey(name: 'enrollment')
  final EnrollmentInfoModel enrollment;

  MyCourseModel({
    required this.id,
    required this.course,
    required this.curriculum,
    required this.enrollment,
  });

  factory MyCourseModel.fromJson(Map<String, dynamic> json) =>
      _$MyCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyCourseModelToJson(this);

  MyCourseEntity toEntity() {
    return MyCourseEntity(
      id: id.toString(),
      course: course.toEntity(),
      curriculum: curriculum.toEntity(),
      enrollment: enrollment.toEntity(),
    );
  }
}

@JsonSerializable()
class CourseInfoModel {
  final int id;
  final String title;
  final String description;
  final String? thumbnail;
  final String price;
  @JsonKey(name: 'formatted_price')
  final String formattedPrice;
  final String status;
  @JsonKey(name: 'difficulty_level')
  final String difficultyLevel;
  @JsonKey(name: 'total_duration_minutes')
  final int totalDurationMinutes;
  @JsonKey(name: 'formatted_duration')
  final String formattedDuration;

  CourseInfoModel({
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

  factory CourseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CourseInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseInfoModelToJson(this);

  CourseInfo toEntity() {
    return CourseInfo(
      id: id.toString(),
      title: title,
      description: description,
      thumbnail: thumbnail,
      price: price,
      formattedPrice: formattedPrice,
      status: status,
      difficultyLevel: difficultyLevel,
      totalDurationMinutes: totalDurationMinutes,
      formattedDuration: formattedDuration,
    );
  }
}

@JsonSerializable()
class CurriculumInfoModel {
  @JsonKey(name: 'total_lessons')
  final int totalLessons;
  @JsonKey(name: 'completed_lessons')
  final int completedLessons;
  @JsonKey(name: 'remaining_lessons')
  final int remainingLessons;
  @JsonKey(name: 'progress_percentage')
  final double progressPercentage;
  @JsonKey(name: 'modules_count')
  final int modulesCount;
  final List<ModuleInfoModel> modules;
  @JsonKey(name: 'next_lesson')
  final NextLessonInfoModel? nextLesson;

  CurriculumInfoModel({
    required this.totalLessons,
    required this.completedLessons,
    required this.remainingLessons,
    required this.progressPercentage,
    required this.modulesCount,
    required this.modules,
    this.nextLesson,
  });

  factory CurriculumInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CurriculumInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurriculumInfoModelToJson(this);

  CurriculumInfo toEntity() {
    return CurriculumInfo(
      totalLessons: totalLessons,
      completedLessons: completedLessons,
      remainingLessons: remainingLessons,
      progressPercentage: progressPercentage,
      modulesCount: modulesCount,
      modules: modules.map((m) => m.toEntity()).toList(),
      nextLesson: nextLesson?.toEntity(),
    );
  }
}

@JsonSerializable()
class ModuleInfoModel {
  @JsonKey(name: 'module_name')
  final String moduleName;
  @JsonKey(name: 'lessons_count')
  final int lessonsCount;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;

  ModuleInfoModel({
    required this.moduleName,
    required this.lessonsCount,
    required this.durationMinutes,
  });

  factory ModuleInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleInfoModelToJson(this);

  ModuleInfo toEntity() {
    return ModuleInfo(
      moduleName: moduleName,
      lessonsCount: lessonsCount,
      durationMinutes: durationMinutes,
    );
  }
}

@JsonSerializable()
class NextLessonInfoModel {
  final int id;
  final String title;
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @JsonKey(name: 'module_name')
  final String moduleName;

  NextLessonInfoModel({
    required this.id,
    required this.title,
    this.durationMinutes,
    required this.moduleName,
  });

  factory NextLessonInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NextLessonInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NextLessonInfoModelToJson(this);

  NextLessonInfo toEntity() {
    return NextLessonInfo(
      id: id.toString(),
      title: title,
      durationMinutes: durationMinutes,
      moduleName: moduleName,
    );
  }
}

@JsonSerializable()
class EnrollmentInfoModel {
  final int id;
  final String status;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'payment_notes')
  final String paymentNotes;
  @JsonKey(name: 'enrolled_at')
  final DateTime enrolledAt;
  @JsonKey(name: 'approved_at')
  final DateTime approvedAt;
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'days_remaining')
  final int daysRemaining;
  @JsonKey(name: 'enrollment_duration_days')
  final int enrollmentDurationDays;

  EnrollmentInfoModel({
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

  factory EnrollmentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentInfoModelToJson(this);

  EnrollmentInfo toEntity() {
    return EnrollmentInfo(
      id: id.toString(),
      status: status,
      paymentMethod: paymentMethod,
      paymentNotes: paymentNotes,
      enrolledAt: enrolledAt,
      approvedAt: approvedAt,
      expiresAt: expiresAt,
      isActive: isActive,
      daysRemaining: daysRemaining,
      enrollmentDurationDays: enrollmentDurationDays,
    );
  }
}
