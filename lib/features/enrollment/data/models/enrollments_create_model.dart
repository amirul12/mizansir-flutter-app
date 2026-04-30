// To parse this JSON data, do
//
//     final enrollmentsCreateModel = enrollmentsCreateModelFromJson(jsonString);

import 'dart:convert';

EnrollmentsCreateModel enrollmentsCreateModelFromJson(String str) =>
    EnrollmentsCreateModel.fromJson(json.decode(str));

String enrollmentsCreateModelToJson(EnrollmentsCreateModel data) =>
    json.encode(data.toJson());

class EnrollmentsCreateModel {
  final Enrollment? enrollment;
  final NextSteps? nextSteps;

  EnrollmentsCreateModel({this.enrollment, this.nextSteps});

  factory EnrollmentsCreateModel.fromJson(Map<String, dynamic> json) =>
      EnrollmentsCreateModel(
        enrollment: json["enrollment"] == null
            ? null
            : Enrollment.fromJson(json["enrollment"]),
        nextSteps: json["next_steps"] == null
            ? null
            : NextSteps.fromJson(json["next_steps"]),
      );

  Map<String, dynamic> toJson() => {
    "enrollment": enrollment?.toJson(),
    "next_steps": nextSteps?.toJson(),
  };
}

class Enrollment {
  final int? id;
  final Course? course;
  final String? status;
  final String? paymentMethod;
  final DateTime? enrolledAt;
  final dynamic approvedAt;
  final dynamic expiresAt;
  final String? paymentNotes;

  Enrollment({
    this.id,
    this.course,
    this.status,
    this.paymentMethod,
    this.enrolledAt,
    this.approvedAt,
    this.expiresAt,
    this.paymentNotes,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
    id: json["id"],
    course: json["course"] == null ? null : Course.fromJson(json["course"]),
    status: json["status"],
    paymentMethod: json["payment_method"],
    enrolledAt: json["enrolled_at"] == null
        ? null
        : DateTime.parse(json["enrolled_at"]),
    approvedAt: json["approved_at"],
    expiresAt: json["expires_at"],
    paymentNotes: json["payment_notes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course": course?.toJson(),
    "status": status,
    "payment_method": paymentMethod,
    "enrolled_at": enrolledAt?.toIso8601String(),
    "approved_at": approvedAt,
    "expires_at": expiresAt,
    "payment_notes": paymentNotes,
  };
}

class Course {
  final String? id;
  final String? title;
  final String? description;
  final String? thumbnail;
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
  final Curriculum? curriculum;

  Course({
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
    this.curriculum,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    price: json["price"],
    formattedPrice: json["formatted_price"],
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
    status: json["status"],
    level: json["level"],
    totalLessons: json["total_lessons"],
    enrolledCount: json["enrolled_count"],
    reviewCount: json["review_count"],
    duration: json["duration"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    curriculum: json["curriculum"] == null
        ? null
        : Curriculum.fromJson(json["curriculum"]),
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
    "curriculum": curriculum?.toJson(),
  };
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
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    icon: json["icon"],
    color: json["color"],
    courseCount: json["course_count"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
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

  Curriculum({this.totalLessons, this.totalDurationMinutes, this.hasDocuments});

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

class NextSteps {
  final String? message;
  final PaymentInstructions? paymentInstructions;

  NextSteps({this.message, this.paymentInstructions});

  factory NextSteps.fromJson(Map<String, dynamic> json) => NextSteps(
    message: json["message"],
    paymentInstructions: json["payment_instructions"] == null
        ? null
        : PaymentInstructions.fromJson(json["payment_instructions"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "payment_instructions": paymentInstructions?.toJson(),
  };
}

class PaymentInstructions {
  final String? title;
  final List<String>? steps;
  final String? note;

  PaymentInstructions({this.title, this.steps, this.note});

  factory PaymentInstructions.fromJson(Map<String, dynamic> json) =>
      PaymentInstructions(
        title: json["title"],
        steps: json["steps"] == null
            ? []
            : List<String>.from(json["steps"]!.map((x) => x)),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x)),
    "note": note,
  };
}
