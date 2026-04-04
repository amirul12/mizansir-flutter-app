// File: lib/features/enrollment/domain/entities/module.dart
import 'package:equatable/equatable.dart';
import 'lesson.dart';

/// Module Entity - Groups lessons by module
class Module extends Equatable {
  final String moduleName;
  final List<Lesson> lessons;

  const Module({
    required this.moduleName,
    this.lessons = const [],
  });

  @override
  List<Object?> get props => [moduleName, lessons];
}
