// File: lib/features/course_browsing/domain/entities/lesson_preview.dart
import 'package:equatable/equatable.dart';

/// Lesson Preview entity - for public view without enrollment
class LessonPreview extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final String? thumbnail;
  final int duration; // in minutes
  final int order;
  final bool isFree; // Can be viewed without enrollment
  final String? videoUrl; // Only available if isFree is true
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonPreview({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.thumbnail,
    required this.duration,
    required this.order,
    required this.isFree,
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if lesson has a thumbnail
  bool get hasThumbnail => thumbnail != null && thumbnail!.isNotEmpty;

  /// Check if lesson has a description
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Check if lesson has a video
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  /// Get formatted duration
  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get duration in hours
  double get durationInHours => duration / 60;

  /// Copy with method
  LessonPreview copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    String? thumbnail,
    int? duration,
    int? order,
    bool? isFree,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LessonPreview(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      isFree: isFree ?? this.isFree,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        duration,
        order,
        isFree,
      ];
}
