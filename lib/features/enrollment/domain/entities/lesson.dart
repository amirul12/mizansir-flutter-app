// File: lib/features/enrollment/domain/entities/lesson.dart
import 'package:equatable/equatable.dart';

/// Lesson Entity (Full version for enrolled courses)
class Lesson extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int duration; // in minutes
  final int order;
  final String? videoUrl;
  final String? thumbnailUrl;
  final bool isFree;
  final bool isCompleted;
  final int? watchTimeSeconds;
  final int? progressPercentage;
  final String? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.duration,
    required this.order,
    this.videoUrl,
    this.thumbnailUrl,
    required this.isFree,
    this.isCompleted = false,
    this.watchTimeSeconds,
    this.progressPercentage,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl!.isNotEmpty;
  bool get hasDescription => description != null && description!.isNotEmpty;

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedWatchTime {
    if (watchTimeSeconds == null) return '0m';
    final minutes = (watchTimeSeconds! / 60).floor();
    if (minutes > 0) return '${minutes}m';
    return '${watchTimeSeconds}s';
  }

  String get episodeLabel => 'Episode $order';

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
        isFree,
        isCompleted,
        watchTimeSeconds,
        progressPercentage,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
