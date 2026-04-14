// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCourseModel _$MyCourseModelFromJson(Map<String, dynamic> json) =>
    MyCourseModel(
      id: (json['id'] as num).toInt(),
      course: CourseInfoModel.fromJson(json['course'] as Map<String, dynamic>),
      curriculum: CurriculumInfoModel.fromJson(
        json['curriculum'] as Map<String, dynamic>,
      ),
      enrollment: EnrollmentInfoModel.fromJson(
        json['enrollment'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MyCourseModelToJson(MyCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'curriculum': instance.curriculum,
      'enrollment': instance.enrollment,
    };

CourseInfoModel _$CourseInfoModelFromJson(Map<String, dynamic> json) =>
    CourseInfoModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String?,
      price: json['price'] as String,
      formattedPrice: json['formatted_price'] as String,
      status: json['status'] as String,
      difficultyLevel: json['difficulty_level'] as String,
      totalDurationMinutes: (json['total_duration_minutes'] as num).toInt(),
      formattedDuration: json['formatted_duration'] as String,
    );

Map<String, dynamic> _$CourseInfoModelToJson(CourseInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'formatted_price': instance.formattedPrice,
      'status': instance.status,
      'difficulty_level': instance.difficultyLevel,
      'total_duration_minutes': instance.totalDurationMinutes,
      'formatted_duration': instance.formattedDuration,
    };

CurriculumInfoModel _$CurriculumInfoModelFromJson(Map<String, dynamic> json) =>
    CurriculumInfoModel(
      totalLessons: (json['total_lessons'] as num).toInt(),
      completedLessons: (json['completed_lessons'] as num).toInt(),
      remainingLessons: (json['remaining_lessons'] as num).toInt(),
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      modulesCount: (json['modules_count'] as num).toInt(),
      modules: (json['modules'] as List<dynamic>)
          .map((e) => ModuleInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextLesson: json['next_lesson'] == null
          ? null
          : NextLessonInfoModel.fromJson(
              json['next_lesson'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CurriculumInfoModelToJson(
  CurriculumInfoModel instance,
) => <String, dynamic>{
  'total_lessons': instance.totalLessons,
  'completed_lessons': instance.completedLessons,
  'remaining_lessons': instance.remainingLessons,
  'progress_percentage': instance.progressPercentage,
  'modules_count': instance.modulesCount,
  'modules': instance.modules,
  'next_lesson': instance.nextLesson,
};

ModuleInfoModel _$ModuleInfoModelFromJson(Map<String, dynamic> json) =>
    ModuleInfoModel(
      moduleName: json['module_name'] as String,
      lessonsCount: (json['lessons_count'] as num).toInt(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$ModuleInfoModelToJson(ModuleInfoModel instance) =>
    <String, dynamic>{
      'module_name': instance.moduleName,
      'lessons_count': instance.lessonsCount,
      'duration_minutes': instance.durationMinutes,
    };

NextLessonInfoModel _$NextLessonInfoModelFromJson(Map<String, dynamic> json) =>
    NextLessonInfoModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      moduleName: json['module_name'] as String,
    );

Map<String, dynamic> _$NextLessonInfoModelToJson(
  NextLessonInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'duration_minutes': instance.durationMinutes,
  'module_name': instance.moduleName,
};

EnrollmentInfoModel _$EnrollmentInfoModelFromJson(Map<String, dynamic> json) =>
    EnrollmentInfoModel(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentNotes: json['payment_notes'] as String,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
      approvedAt: DateTime.parse(json['approved_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isActive: json['is_active'] as bool,
      daysRemaining: (json['days_remaining'] as num).toInt(),
      enrollmentDurationDays: (json['enrollment_duration_days'] as num).toInt(),
    );

Map<String, dynamic> _$EnrollmentInfoModelToJson(
  EnrollmentInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'payment_method': instance.paymentMethod,
  'payment_notes': instance.paymentNotes,
  'enrolled_at': instance.enrolledAt.toIso8601String(),
  'approved_at': instance.approvedAt.toIso8601String(),
  'expires_at': instance.expiresAt.toIso8601String(),
  'is_active': instance.isActive,
  'days_remaining': instance.daysRemaining,
  'enrollment_duration_days': instance.enrollmentDurationDays,
};
