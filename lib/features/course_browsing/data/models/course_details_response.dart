// To parse this JSON data, do
//
//     final courseDetailsResponse = courseDetailsResponseFromJson(jsonString);

import 'dart:convert';

CourseDetailsResponse courseDetailsResponseFromJson(String str) => CourseDetailsResponse.fromJson(json.decode(str));

String courseDetailsResponseToJson(CourseDetailsResponse data) => json.encode(data.toJson());

class CourseDetailsResponse {
    final Course? course;
    final EnrollmentStatus? enrollmentStatus;
    final bool? canEnroll;

    CourseDetailsResponse({
        this.course,
        this.enrollmentStatus,
        this.canEnroll,
    });

    factory CourseDetailsResponse.fromJson(Map<String, dynamic> json) => CourseDetailsResponse(
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        enrollmentStatus: json["enrollment_status"] == null ? null : EnrollmentStatus.fromJson(json["enrollment_status"]),
        canEnroll: json["can_enroll"],
    );

    Map<String, dynamic> toJson() => {
        "course": course?.toJson(),
        "enrollment_status": enrollmentStatus?.toJson(),
        "can_enroll": canEnroll,
    };
}

class Course {
    final String? id;
    final String? title;
    final String? description;
    final String? thumbnail;
    final int? price;
    final String? formattedPrice;
    final String? status;
    final String? level;
    final String? language;
    final int? totalLessons;
    final int? enrolledCount;
    final dynamic rating;
    final dynamic reviewCount;
    final String? duration;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Curriculum? curriculum;
    final Stats? stats;
    final Meta? meta;
    final bool? isEnrolled;

    Course({
        this.id,
        this.title,
        this.description,
        this.thumbnail,
        this.price,
        this.formattedPrice,
        this.status,
        this.level,
        this.language,
        this.totalLessons,
        this.enrolledCount,
        this.rating,
        this.reviewCount,
        this.duration,
        this.createdAt,
        this.updatedAt,
        this.curriculum,
        this.stats,
        this.meta,
        this.isEnrolled,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        formattedPrice: json["formatted_price"],
        status: json["status"],
        level: json["level"],
        language: json["language"],
        totalLessons: json["total_lessons"],
        enrolledCount: json["enrolled_count"],
        rating: json["rating"],
        reviewCount: json["review_count"],
        duration: json["duration"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        curriculum: json["curriculum"] == null ? null : Curriculum.fromJson(json["curriculum"]),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        isEnrolled: json["is_enrolled"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "price": price,
        "formatted_price": formattedPrice,
        "status": status,
        "level": level,
        "language": language,
        "total_lessons": totalLessons,
        "enrolled_count": enrolledCount,
        "rating": rating,
        "review_count": reviewCount,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "curriculum": curriculum?.toJson(),
        "stats": stats?.toJson(),
        "meta": meta?.toJson(),
        "is_enrolled": isEnrolled,
    };
}

class Curriculum {
    final int? totalLessons;
    final int? totalDurationMinutes;
    final String? formattedDuration;
    final int? previewLessonsCount;
    final int? modulesCount;
    final List<Module>? modules;

    Curriculum({
        this.totalLessons,
        this.totalDurationMinutes,
        this.formattedDuration,
        this.previewLessonsCount,
        this.modulesCount,
        this.modules,
    });

    factory Curriculum.fromJson(Map<String, dynamic> json) => Curriculum(
        totalLessons: json["total_lessons"],
        totalDurationMinutes: json["total_duration_minutes"],
        formattedDuration: json["formatted_duration"],
        previewLessonsCount: json["preview_lessons_count"],
        modulesCount: json["modules_count"],
        modules: json["modules"] == null ? [] : List<Module>.from(json["modules"]!.map((x) => Module.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_lessons": totalLessons,
        "total_duration_minutes": totalDurationMinutes,
        "formatted_duration": formattedDuration,
        "preview_lessons_count": previewLessonsCount,
        "modules_count": modulesCount,
        "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x.toJson())),
    };
}

class Module {
    final String? moduleName;
    final int? lessonsCount;
    final int? totalDurationMinutes;
    final List<Lesson>? lessons;

    Module({
        this.moduleName,
        this.lessonsCount,
        this.totalDurationMinutes,
        this.lessons,
    });

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleName: json["module_name"],
        lessonsCount: json["lessons_count"],
        totalDurationMinutes: json["total_duration_minutes"],
        lessons: json["lessons"] == null ? [] : List<Lesson>.from(json["lessons"]!.map((x) => Lesson.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "module_name": moduleName,
        "lessons_count": lessonsCount,
        "total_duration_minutes": totalDurationMinutes,
        "lessons": lessons == null ? [] : List<dynamic>.from(lessons!.map((x) => x.toJson())),
    };
}

class Lesson {
    final int? id;
    final String? title;
    final String? description;
    final int? durationMinutes;
    final bool? isPreview;
    final dynamic thumbnail;
    final String? contentType;

    Lesson({
        this.id,
        this.title,
        this.description,
        this.durationMinutes,
        this.isPreview,
        this.thumbnail,
        this.contentType,
    });

    factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        durationMinutes: json["duration_minutes"],
        isPreview: json["is_preview"],
        thumbnail: json["thumbnail"],
        contentType: json["content_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "duration_minutes": durationMinutes,
        "is_preview": isPreview,
        "thumbnail": thumbnail,
        "content_type": contentType,
    };
}

class Meta {
    final bool? isNew;
    final String? lastUpdated;

    Meta({
        this.isNew,
        this.lastUpdated,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        isNew: json["is_new"],
        lastUpdated: json["last_updated"],
    );

    Map<String, dynamic> toJson() => {
        "is_new": isNew,
        "last_updated": lastUpdated,
    };
}

class Stats {
    final int? enrollmentCount;
    final int? activeEnrollments;
    final int? pendingEnrollments;
    final bool? isPopular;
    final bool? hasDocuments;

    Stats({
        this.enrollmentCount,
        this.activeEnrollments,
        this.pendingEnrollments,
        this.isPopular,
        this.hasDocuments,
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        enrollmentCount: json["enrollment_count"],
        activeEnrollments: json["active_enrollments"],
        pendingEnrollments: json["pending_enrollments"],
        isPopular: json["is_popular"],
        hasDocuments: json["has_documents"],
    );

    Map<String, dynamic> toJson() => {
        "enrollment_count": enrollmentCount,
        "active_enrollments": activeEnrollments,
        "pending_enrollments": pendingEnrollments,
        "is_popular": isPopular,
        "has_documents": hasDocuments,
    };
}

class EnrollmentStatus {
    final String? status;
    final DateTime? enrolledAt;
    final DateTime? expiresAt;
    final bool? isActive;

    EnrollmentStatus({
        this.status,
        this.enrolledAt,
        this.expiresAt,
        this.isActive,
    });

    factory EnrollmentStatus.fromJson(Map<String, dynamic> json) => EnrollmentStatus(
        status: json["status"],
        enrolledAt: json["enrolled_at"] == null ? null : DateTime.parse(json["enrolled_at"]),
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "enrolled_at": enrolledAt?.toIso8601String(),
        "expires_at": expiresAt?.toIso8601String(),
        "is_active": isActive,
    };
}
