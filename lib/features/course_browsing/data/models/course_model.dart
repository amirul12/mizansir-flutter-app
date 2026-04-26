// To parse this JSON data, do
//
//     final courseListResponse = courseListResponseFromJson(jsonString);

import 'dart:convert';

CourseListResponse courseListResponseFromJson(String str) => CourseListResponse.fromJson(json.decode(str));

String courseListResponseToJson(CourseListResponse data) => json.encode(data.toJson());

class CourseListResponse {
    final List<CourseModel>? items;
    final Pagination? pagination;

    CourseListResponse({
        this.items,
        this.pagination,
    });

    factory CourseListResponse.fromJson(Map<String, dynamic> json) => CourseListResponse(
        items: json["items"] == null ? [] : List<CourseModel>.from(json["items"]!.map((x) => CourseModel.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class CourseModel {
    final String? id;
    final String? title;
    final String? description;
    final dynamic thumbnail;
    final int? price;
    final String? formattedPrice;
    final Category? category;
    final String? status;
    final String? level;
    final int? totalLessons;
    final int? enrolledCount;
    final int? reviewCount;
    final String? duration;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isEnrolled;
    final Stats? stats;
    final Curriculum? curriculum;
    final double? rating;
    final String? instructor;
    final List<Map<String, dynamic>>? modules;
    final int? modulesCount;
    final String? language;

    CourseModel({
        this.id,
        this.title,
        this.description,
        this.thumbnail,
        this.price,
        this.formattedPrice,
        this.category,
        this.status,
        this.level,
        this.totalLessons,
        this.enrolledCount,
        this.reviewCount,
        this.duration,
        this.createdAt,
        this.updatedAt,
        this.isEnrolled,
        this.stats,
        this.curriculum,
        this.rating,
        this.instructor,
        this.modules,
        this.modulesCount,
        this.language,
    });

    factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json["id"]?.toString(),
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        formattedPrice: json["formatted_price"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        status: json["status"],
        level: json["level"],
        totalLessons: json["total_lessons"],
        enrolledCount: json["enrolled_count"],
        reviewCount: json["review_count"],
        duration: json["duration"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        isEnrolled: json["is_enrolled"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        curriculum: json["curriculum"] == null ? null : Curriculum.fromJson(json["curriculum"]),
        rating: json["rating"]?.toDouble(),
        instructor: json["instructor"] ?? json["instructor_name"],
        modules: json["modules"] == null ? null : List<Map<String, dynamic>>.from(json["modules"]),
        modulesCount: json["modules_count"] ?? (json["modules"] as List?)?.length,
        language: json["language"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "price": price,
        "formatted_price": formattedPrice,
        "category": category?.toJson(),
        "status": status,
        "level": level,
        "total_lessons": totalLessons,
        "enrolled_count": enrolledCount,
        "review_count": reviewCount,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_enrolled": isEnrolled,
        "stats": stats?.toJson(),
        "curriculum": curriculum?.toJson(),
        "rating": rating,
        "instructor": instructor,
        "modules": modules,
        "modules_count": modulesCount,
        "language": language,
    };

    // UI Helpers
    String get levelLabel => level?.toUpperCase() ?? 'BEGINNER';
    String get displayPrice => formattedPrice ?? (price == 0 || price == null ? 'Free' : '\$${price}');
    bool get isFree => price == 0 || price == null;
    int get totalLessonsCount => totalLessons ?? 0;
    String? get formattedDuration => duration;
    bool get hasCurriculum => curriculum != null || (modules != null && modules!.isNotEmpty);
    bool get hasCategory => category != null && category!.name != null;
}

class Category {
    final String? id;
    final String? name;
    final String? slug;
    final String? description;
    final dynamic icon;
    final dynamic color;
    final int? courseCount;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Category({
        this.id,
        this.name,
        this.slug,
        this.description,
        this.icon,
        this.color,
        this.courseCount,
        this.createdAt,
        this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"]?.toString(),
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        icon: json["icon"],
        color: json["color"],
        courseCount: json["course_count"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "icon": icon,
        "color": color,
        "course_count": courseCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Curriculum {
    final int? totalLessons;
    final int? totalDurationMinutes;
    final bool? hasDocuments;

    Curriculum({
        this.totalLessons,
        this.totalDurationMinutes,
        this.hasDocuments,
    });

    factory Curriculum.fromJson(Map<String, dynamic> json) => Curriculum(
        totalLessons: json["total_lessons"],
        totalDurationMinutes: json["total_duration_minutes"],
        hasDocuments: json["has_documents"],
    );

    Map<String, dynamic> toJson() => {
        "total_lessons": totalLessons,
        "total_duration_minutes": totalDurationMinutes,
        "has_documents": hasDocuments,
    };
}

class Stats {
    final int? enrollmentCount;
    final bool? isPopular;
    final bool? hasDocuments;

    Stats({
        this.enrollmentCount,
        this.isPopular,
        this.hasDocuments,
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        enrollmentCount: json["enrollment_count"],
        isPopular: json["is_popular"],
        hasDocuments: json["has_documents"],
    );

    Map<String, dynamic> toJson() => {
        "enrollment_count": enrollmentCount,
        "is_popular": isPopular,
        "has_documents": hasDocuments,
    };
}

class Pagination {
    final int? currentPage;
    final int? from;
    final int? lastPage;
    final Links? links;
    final String? path;
    final int? perPage;
    final int? to;
    final int? total;

    Pagination({
        this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links?.toJson(),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Links {
    final String? first;
    final String? last;
    final dynamic prev;
    final dynamic next;

    Links({
        this.first,
        this.last,
        this.prev,
        this.next,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}
