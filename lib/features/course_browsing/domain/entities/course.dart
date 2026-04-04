// File: lib/features/course_browsing/domain/entities/course.dart
import 'category.dart' show Category;

/// Course entity
class Course {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final double price;
  final Category? category;
  final String? instructor;
  final String status; // published, draft, archived
  final String? level; // beginner, intermediate, advanced
  final String? language;
  final int totalLessons;
  final int enrolledCount;
  final double? rating;
  final int reviewCount;
  final String? duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
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

  /// Check if course is free
  bool get isFree => price == 0;

  /// Check if course is published
  bool get isPublished => status == 'published';

  /// Check if course has a category
  bool get hasCategory => category != null;

  /// Get formatted price
  String get formattedPrice {
    if (isFree) return 'Free';
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Get rating text
  String get ratingText {
    if (rating == null || rating == 0) return 'No ratings';
    return '$rating ($reviewCount reviews)';
  }

  /// Check if course is for beginners
  bool get isBeginner => level == 'beginner';

  /// Check if course is advanced
  bool get isAdvanced => level == 'advanced';

  /// Get level label
  String get levelLabel {
    switch (level) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return 'All Levels';
    }
  }

  /// Copy with method
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnail,
    double? price,
    Category? category,
    String? instructor,
    String? status,
    String? level,
    String? language,
    int? totalLessons,
    int? enrolledCount,
    double? rating,
    int? reviewCount,
    String? duration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      price: price ?? this.price,
      category: category ?? this.category,
      instructor: instructor ?? this.instructor,
      status: status ?? this.status,
      level: level ?? this.level,
      language: language ?? this.language,
      totalLessons: totalLessons ?? this.totalLessons,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
