// File: lib/features/course_browsing/data/models/category_model.dart
 

import 'package:mizansir/features/course_browsing/data/models/course_model.dart';

/// Category Model
class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final int courseCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.courseCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      courseCount: json['course_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'course_count': courseCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert to Entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      icon: icon,
      color: color,
      courseCount: courseCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  
}
