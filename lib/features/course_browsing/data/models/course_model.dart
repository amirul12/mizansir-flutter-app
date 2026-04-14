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
  final String? formattedPrice;
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
  final Map<String, dynamic>? stats;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? curriculum;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.price,
    this.formattedPrice,
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
    this.stats,
    this.meta,
    this.curriculum,
  });

  /// Convert from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested stats object for enrollment count
    int enrolledCount = 0;
    if (json['stats'] is Map && json['stats']['total_enrollments'] is int) {
      enrolledCount = json['stats']['total_enrollments'] as int;
    } else if (json['enrolled_count'] is int) {
      enrolledCount = json['enrolled_count'] as int;
    } else if (json['enrollment_count'] is int) {
      enrolledCount = json['enrollment_count'] as int;
    }

    // Handle price - can be string or number
    double price = 0.0;
    if (json['price'] is num) {
      price = (json['price'] as num).toDouble();
    } else if (json['price'] is String) {
      price = double.tryParse(json['price']) ?? 0.0;
    }

    // Handle formatted_price
    String? formattedPrice;
    if (json['formatted_price'] is String) {
      formattedPrice = json['formatted_price'];
    }

    // Handle rating - can be in stats or root
    double? rating;
    if (json['stats'] is Map && json['stats']['average_rating'] is num) {
      rating = (json['stats']['average_rating'] as num).toDouble();
    } else if (json['rating'] is num) {
      rating = (json['rating'] as num).toDouble();
    }

    // Handle review count
    int reviewCount = 0;
    if (json['stats'] is Map && json['stats']['total_reviews'] is int) {
      reviewCount = json['stats']['total_reviews'] as int;
    } else if (json['review_count'] is int) {
      reviewCount = json['review_count'] as int;
    }

    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      price: price,
      formattedPrice: formattedPrice,
      category: json['category'],
      instructor: json['instructor'],
      status: json['status'] ?? 'draft',
      level: json['level'],
      language: json['language'],
      totalLessons: json['total_lessons'] ?? 0,
      enrolledCount: enrolledCount,
      rating: rating,
      reviewCount: reviewCount,
      duration: json['duration'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      stats: json['stats'] is Map ? json['stats'] as Map<String, dynamic> : null,
      meta: json['meta'] is Map ? json['meta'] as Map<String, dynamic> : null,
      curriculum: json['curriculum'] is Map ? json['curriculum'] as Map<String, dynamic> : null,
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
      if (formattedPrice != null) 'formatted_price': formattedPrice,
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
      if (stats != null) 'stats': stats,
      if (meta != null) 'meta': meta,
      if (curriculum != null) 'curriculum': curriculum,
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
      formattedPrice: formattedPrice,
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
      stats: stats,
      meta: meta,
      curriculum: curriculum,
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
      formattedPrice: entity.formattedPrice,
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
      stats: entity.stats,
      meta: entity.meta,
      curriculum: entity.curriculum,
    );
  }

  @override
  List<Object?> get props => [id, title, price];
}
