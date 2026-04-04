// File: lib/features/course_browsing/domain/entities/category.dart
import 'package:equatable/equatable.dart';

/// Category entity
class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final int courseCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.courseCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if category has an icon
  bool get hasIcon => icon != null && icon!.isNotEmpty;

  /// Check if category has a color
  bool get hasColor => color != null && color!.isNotEmpty;

  /// Get category icon or default
  String get categoryIcon => hasIcon ? icon! : 'category';

  /// Copy with method
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    int? courseCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      courseCount: courseCount ?? this.courseCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, icon, color, courseCount];
}
