// File: lib/features/enrollment/data/models/module_model.dart
import 'package:equatable/equatable.dart';
import 'lesson_model.dart';
import '../../domain/entities/module.dart';

/// Module Model - Contains lessons grouped by module
class ModuleModel extends Equatable {
  final String moduleName;
  final List<LessonModel> lessons;

  const ModuleModel({
    required this.moduleName,
    this.lessons = const [],
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    List<LessonModel> lessonsList = [];
    if (json['lessons'] != null && json['lessons'] is List) {
      lessonsList = (json['lessons'] as List)
          .map((lesson) => LessonModel.fromJson(lesson as Map<String, dynamic>))
          .toList();
    }

    return ModuleModel(
      moduleName: json['module_name'] ?? '',
      lessons: lessonsList,
    );
  }

  Module toEntity() {
    return Module(
      moduleName: moduleName,
      lessons: lessons.map((lesson) => lesson.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [moduleName, lessons];
}
