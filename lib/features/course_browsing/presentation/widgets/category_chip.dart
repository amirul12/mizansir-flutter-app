// File: lib/features/course_browsing/presentation/widgets/category_chip.dart
import 'package:flutter/material.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart';
 

/// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (category.color != null
                  ? Color(int.parse(category.color!.replaceAll('#', '0xFF')))
                  : Theme.of(context).primaryColor)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey[400]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.icon) ...[
              Icon(
                _getIconData(category.icon!),
                size: 18,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category.name!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            if (category.courseCount! > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white24
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category.courseCount.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : Colors.grey[800],
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Map common icon names to IconData
    switch (iconName.toLowerCase()) {
      case 'code':
        return Icons.code;
      case 'business':
        return Icons.business;
      case 'design':
        return Icons.design_services;
      case 'music':
        return Icons.music_note;
      case 'science':
        return Icons.science;
      case 'language':
        return Icons.translate;
      case 'math':
        return Icons.calculate;
      case 'art':
        return Icons.palette;
      case 'camera':
        return Icons.camera_alt;
      case 'book':
        return Icons.menu_book;
      default:
        return Icons.category;
    }
  }
}
