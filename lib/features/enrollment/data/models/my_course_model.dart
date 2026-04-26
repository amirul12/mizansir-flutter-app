// To parse this JSON data, do
//
//     final myCourseModel = myCourseModelFromJson(jsonString);

import 'dart:convert';

List<MyCourseModel> myCourseModelFromJson(String str) =>
    List<MyCourseModel>.from(
      json.decode(str).map((x) => MyCourseModel.fromJson(x)),
    );

String myCourseModelToJson(List<MyCourseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyCourseModel {
  final int? id;
  final Course? course;
  final Curriculum? curriculum;
  final Enrollment? enrollment;

  MyCourseModel({this.id, this.course, this.curriculum, this.enrollment});

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
    id: json["id"],
    course: json["course"] == null ? null : Course.fromJson(json["course"]),
    curriculum: json["curriculum"] == null
        ? null
        : Curriculum.fromJson(json["curriculum"]),
    enrollment: json["enrollment"] == null
        ? null
        : Enrollment.fromJson(json["enrollment"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course": course?.toJson(),
    "curriculum": curriculum?.toJson(),
    "enrollment": enrollment?.toJson(),
  };
}

class Course {
  final int? id;
  final String? title;
  final String? description;
  final dynamic thumbnail;
  final String? price;
  final String? formattedPrice;
  final String? status;
  final String? difficultyLevel;
  final int? totalDurationMinutes;
  final String? formattedDuration;

  Course({
    this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.price,
    this.formattedPrice,
    this.status,
    this.difficultyLevel,
    this.totalDurationMinutes,
    this.formattedDuration,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    price: json["price"],
    formattedPrice: json["formatted_price"],
    status: json["status"],
    difficultyLevel: json["difficulty_level"],
    totalDurationMinutes: json["total_duration_minutes"],
    formattedDuration: json["formatted_duration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "thumbnail": thumbnail,
    "price": price,
    "formatted_price": formattedPrice,
    "status": status,
    "difficulty_level": difficultyLevel,
    "total_duration_minutes": totalDurationMinutes,
    "formatted_duration": formattedDuration,
  };
}

class Curriculum {
  final int? totalLessons;
  final int? completedLessons;
  final int? remainingLessons;
  final double? progressPercentage;
  final int? modulesCount;
  final List<Module>? modules;
  final NextLesson? nextLesson;

  Curriculum({
    this.totalLessons,
    this.completedLessons,
    this.remainingLessons,
    this.progressPercentage,
    this.modulesCount,
    this.modules,
    this.nextLesson,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) => Curriculum(
    totalLessons: json["total_lessons"],
    completedLessons: json["completed_lessons"],
    remainingLessons: json["remaining_lessons"],
    progressPercentage: json["progress_percentage"]?.toDouble(),
    modulesCount: json["modules_count"],
    modules: json["modules"] == null
        ? []
        : List<Module>.from(json["modules"]!.map((x) => Module.fromJson(x))),
    nextLesson: json["next_lesson"] == null
        ? null
        : NextLesson.fromJson(json["next_lesson"]),
  );

  Map<String, dynamic> toJson() => {
    "total_lessons": totalLessons,
    "completed_lessons": completedLessons,
    "remaining_lessons": remainingLessons,
    "progress_percentage": progressPercentage,
    "modules_count": modulesCount,
    "modules": modules == null
        ? []
        : List<dynamic>.from(modules!.map((x) => x.toJson())),
    "next_lesson": nextLesson?.toJson(),
  };
}

class Module {
  final String? moduleName;
  final int? lessonsCount;
  final int? durationMinutes;

  Module({this.moduleName, this.lessonsCount, this.durationMinutes});

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleName: json["module_name"],
    lessonsCount: json["lessons_count"],
    durationMinutes: json["duration_minutes"],
  );

  Map<String, dynamic> toJson() => {
    "module_name": moduleName,
    "lessons_count": lessonsCount,
    "duration_minutes": durationMinutes,
  };
}

class NextLesson {
  final int? id;
  final String? title;
  final int? durationMinutes;
  final String? moduleName;

  NextLesson({this.id, this.title, this.durationMinutes, this.moduleName});

  factory NextLesson.fromJson(Map<String, dynamic> json) => NextLesson(
    id: json["id"],
    title: json["title"],
    durationMinutes: json["duration_minutes"],
    moduleName: json["module_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "duration_minutes": durationMinutes,
    "module_name": moduleName,
  };
}

class Enrollment {
  final int? id;
  final String? status;
  final String? paymentMethod;
  final String? paymentNotes;
  final DateTime? enrolledAt;
  final DateTime? approvedAt;
  final DateTime? expiresAt;
  final bool? isActive;
  final int? daysRemaining;
  final int? enrollmentDurationDays;

  Enrollment({
    this.id,
    this.status,
    this.paymentMethod,
    this.paymentNotes,
    this.enrolledAt,
    this.approvedAt,
    this.expiresAt,
    this.isActive,
    this.daysRemaining,
    this.enrollmentDurationDays,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
    id: json["id"],
    status: json["status"],
    paymentMethod: json["payment_method"],
    paymentNotes: json["payment_notes"],
    enrolledAt: json["enrolled_at"] == null
        ? null
        : DateTime.parse(json["enrolled_at"]),
    approvedAt: json["approved_at"] == null
        ? null
        : DateTime.parse(json["approved_at"]),
    expiresAt: json["expires_at"] == null
        ? null
        : DateTime.parse(json["expires_at"]),
    isActive: json["is_active"],
    daysRemaining: json["days_remaining"],
    enrollmentDurationDays: json["enrollment_duration_days"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "payment_method": paymentMethod,
    "payment_notes": paymentNotes,
    "enrolled_at": enrolledAt?.toIso8601String(),
    "approved_at": approvedAt?.toIso8601String(),
    "expires_at": expiresAt?.toIso8601String(),
    "is_active": isActive,
    "days_remaining": daysRemaining,
    "enrollment_duration_days": enrollmentDurationDays,
  };
}
