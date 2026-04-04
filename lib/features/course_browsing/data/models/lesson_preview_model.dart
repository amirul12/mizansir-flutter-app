// File: lib/features/course_browsing/data/models/lesson_preview_model.dart
import '../../domain/entities/lesson_preview.dart';

/// Lesson Preview Model
class LessonPreviewModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final String? thumbnail;
  final int duration;
  final int order;
  final bool isFree;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonPreviewModel({
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

  /// Convert from JSON
  factory LessonPreviewModel.fromJson(Map<String, dynamic> json) {
    return LessonPreviewModel(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'],
      duration: json['duration'] ?? 0,
      order: json['order'] ?? 0,
      isFree: json['is_free'] ?? false,
      videoUrl: json['video_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'duration': duration,
      'order': order,
      'is_free': isFree,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert to Entity
  LessonPreview toEntity() {
    return LessonPreview(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      thumbnail: thumbnail,
      duration: duration,
      order: order,
      isFree: isFree,
      videoUrl: videoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert from Entity
  factory LessonPreviewModel.fromEntity(LessonPreview entity) {
    return LessonPreviewModel(
      id: entity.id,
      courseId: entity.courseId,
      title: entity.title,
      description: entity.description,
      thumbnail: entity.thumbnail,
      duration: entity.duration,
      order: entity.order,
      isFree: entity.isFree,
      videoUrl: entity.videoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
