// File: lib/features/enrollment/data/models/lesson_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson.dart';

/// Lesson Model
class LessonModel extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int duration;
  final int order;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? youtubeEmbedUrl;
  final String? youtubeVideoId;
  final bool isFree;
  final bool isCompleted;
  final int? watchTimeSeconds;
  final int? progressPercentage;
  final String? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.duration,
    required this.order,
    this.videoUrl,
    this.thumbnailUrl,
    this.youtubeEmbedUrl,
    this.youtubeVideoId,
    required this.isFree,
    this.isCompleted = false,
    this.watchTimeSeconds,
    this.progressPercentage,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      duration: json['duration'] is num ? (json['duration'] as num).toInt() : 0,
      order: json['order'] is num ? (json['order'] as num).toInt() : 0,
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      youtubeEmbedUrl: json['youtube_embed_url'],
      youtubeVideoId: json['youtube_video_id'],
      isFree: json['is_free'] ?? false,
      isCompleted: json['is_completed'] ?? false,
      watchTimeSeconds: json['watch_time_seconds'] is num
          ? (json['watch_time_seconds'] as num).toInt()
          : null,
      progressPercentage: json['progress_percentage'] is num
          ? (json['progress_percentage'] as num).toInt()
          : null,
      completedAt: json['completed_at'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Lesson toEntity() {
    return Lesson(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      duration: duration,
      order: order,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      youtubeEmbedUrl: youtubeEmbedUrl,
      youtubeVideoId: youtubeVideoId,
      isFree: isFree,
      isCompleted: isCompleted,
      watchTimeSeconds: watchTimeSeconds,
      progressPercentage: progressPercentage,
      completedAt: completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        duration,
        order,
        videoUrl,
        thumbnailUrl,
        youtubeEmbedUrl,
        youtubeVideoId,
        isFree,
        isCompleted,
        watchTimeSeconds,
        progressPercentage,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
