// File: lib/features/course_browsing/data/models/course_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/category.dart';
import 'category_model.dart' show CategoryModel;

/// Course Model
class CourseModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final double price;
  final Map<String, dynamic>? category;
  final String? instructor;
  final String status;
  final String? level;
  final String? language;
  final int totalLessons;
  final int enrolledCount;
  final double? rating;
  final int reviewCount;
  final String? duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.price,
    this.category,
    this.instructor,
    required this.status,
    this.level,
    this.language,
    required this.totalLessons,
    required this.enrolledCount,
    this.rating,
    required this.reviewCount,
    this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      price: (json['price'] is num ? (json['price'] as num).toDouble() : 0.0),
      category: json['category'],
      instructor: json['instructor'],
      status: json['status'] ?? 'draft',
      level: json['level'],
      language: json['language'],
      totalLessons: json['total_lessons'] ?? 0,
      enrolledCount: json['enrolled_count'] ?? 0,
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'] ?? 0,
      duration: json['duration'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'price': price,
      'category': category,
      'instructor': instructor,
      'status': status,
      'level': level,
      'language': language,
      'total_lessons': totalLessons,
      'enrolled_count': enrolledCount,
      'rating': rating,
      'review_count': reviewCount,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert to Entity
  Course toEntity() {
    return Course(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      price: price,
      category: category != null ? CategoryModel.fromJson(category!).toEntity() : null,
      instructor: instructor,
      status: status,
      level: level,
      language: language,
      totalLessons: totalLessons,
      enrolledCount: enrolledCount,
      rating: rating,
      reviewCount: reviewCount,
      duration: duration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert from Entity
  factory CourseModel.fromEntity(Course entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      thumbnail: entity.thumbnail,
      price: entity.price,
      category: entity.category != null
          ? CategoryModel.fromEntity(entity.category!).toJson()
          : null,
      instructor: entity.instructor,
      status: entity.status,
      level: entity.level,
      language: entity.language,
      totalLessons: entity.totalLessons,
      enrolledCount: entity.enrolledCount,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      duration: entity.duration,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, price];
}
