// File: lib/features/course_browsing/domain/entities/course.dart
import 'category.dart' show Category;

/// Course entity
class Course {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final double price;
  final String? formattedPrice;
  final Category? category;
  final String? instructor;
  final String status; // published, draft, archived, active
  final String? level; // beginner, intermediate, advanced
  final String? language;
  final int totalLessons;
  final int enrolledCount;
  final double? rating;
  final int reviewCount;
  final String? duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isEnrolled;
  final Map<String, dynamic>? stats;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? curriculum;

  const Course({
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
    this.isEnrolled,
    this.stats,
    this.meta,
    this.curriculum,
  });

  /// Check if course is free
  bool get isFree => price == 0;

  /// Check if course is published
  bool get isPublished => status == 'published' || status == 'active';

  /// Check if course has a category
  bool get hasCategory => category != null;

  /// Get formatted price (uses API formatted_price if available, otherwise generates)
  String get displayPrice {
    if (formattedPrice != null) return formattedPrice!;
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

  /// Get total lessons from curriculum or fallback to totalLessons field
  int get totalLessonsCount {
    if (curriculum != null && curriculum!['total_lessons'] is int) {
      return curriculum!['total_lessons'] as int;
    }
    return totalLessons;
  }

  /// Get formatted duration from curriculum
  String? get formattedDuration {
    if (curriculum != null && curriculum!['formatted_duration'] is String) {
      return curriculum!['formatted_duration'] as String;
    }
    return duration;
  }

  /// Get total duration in minutes
  int? get totalDurationMinutes {
    if (curriculum != null && curriculum!['total_duration_minutes'] is int) {
      return curriculum!['total_duration_minutes'] as int;
    }
    return null;
  }

  /// Get modules count
  int? get modulesCount {
    if (curriculum != null && curriculum!['modules_count'] is int) {
      return curriculum!['modules_count'] as int;
    }
    return null;
  }

  /// Get preview lessons count
  int? get previewLessonsCount {
    if (curriculum != null && curriculum!['preview_lessons_count'] is int) {
      return curriculum!['preview_lessons_count'] as int;
    }
    return null;
  }

  /// Get modules list
  List<Map<String, dynamic>>? get modules {
    if (curriculum != null && curriculum!['modules'] is List) {
      return (curriculum!['modules'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return null;
  }

  /// Check if course has curriculum
  bool get hasCurriculum => curriculum != null;

  /// Copy with method
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnail,
    double? price,
    String? formattedPrice,
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
    Map<String, dynamic>? stats,
    Map<String, dynamic>? meta,
    Map<String, dynamic>? curriculum,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      price: price ?? this.price,
      formattedPrice: formattedPrice ?? this.formattedPrice,
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
      stats: stats ?? this.stats,
      meta: meta ?? this.meta,
      curriculum: curriculum ?? this.curriculum,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
