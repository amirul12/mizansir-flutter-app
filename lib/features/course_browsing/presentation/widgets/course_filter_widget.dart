// File: lib/features/course_browsing/presentation/widgets/course_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';
 
import '../../domain/entities/course_filter.dart';
 

/// Course Filter Widget
class CourseFilterWidget extends StatelessWidget {
  final CourseFilter filter;
  final List<Category> categories;
  final Function(CourseFilter) onFilterChanged;
  final VoidCallback? onClearFilters;

  const CourseFilterWidget({
    super.key,
    required this.filter,
    required this.categories,
    required this.onFilterChanged,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (onClearFilters != null && filter.hasActiveFilters)
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Category Filter
          if (categories.isNotEmpty) ...[
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // All option
                FilterChip(
                  label: const Text('All'),
                  selected: filter.categoryId == null,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(filter.copyWith(categoryId: null));
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  checkmarkColor: Colors.white,
                ),
                // Categories
                ...categories.map((category) {
                  return FilterChip(
                    label: Text(category.name!),
                    selected: filter.categoryId == category.id,
                    onSelected: (selected) {
                      onFilterChanged(
                        filter.copyWith(categoryId: selected ? category.id : null),
                      );
                    },
                    selectedColor: category.color != null
                        ? Color(int.parse('0xFF${category.color!.substring(1)}'))
                        : Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white,
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Level Filter
          Text(
            'Level',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('All Levels'),
                selected: filter.level == null,
                onSelected: (selected) {
                  if (selected) {
                    onFilterChanged(filter.copyWith(level: null));
                  }
                },
                selectedColor: Theme.of(context).primaryColor,
                checkmarkColor: Colors.white,
              ),
              FilterChip(
                label: const Text('Beginner'),
                selected: filter.level == 'beginner',
                onSelected: (selected) {
                  onFilterChanged(
                    filter.copyWith(level: selected ? 'beginner' : null),
                  );
                },
                selectedColor: Colors.green,
                checkmarkColor: Colors.white,
              ),
              FilterChip(
                label: const Text('Intermediate'),
                selected: filter.level == 'intermediate',
                onSelected: (selected) {
                  onFilterChanged(
                    filter.copyWith(level: selected ? 'intermediate' : null),
                  );
                },
                selectedColor: Colors.orange,
                checkmarkColor: Colors.white,
              ),
              FilterChip(
                label: const Text('Advanced'),
                selected: filter.level == 'advanced',
                onSelected: (selected) {
                  onFilterChanged(
                    filter.copyWith(level: selected ? 'advanced' : null),
                  );
                },
                selectedColor: Colors.red,
                checkmarkColor: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price Filter
          Text(
            'Price',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: const Text('All'),
                  selected: filter.minPrice == null && filter.maxPrice == null,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(
                        filter.copyWith(minPrice: null, maxPrice: null),
                      );
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  checkmarkColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Free'),
                  selected: filter.minPrice == 0 && filter.maxPrice == 0,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(
                        filter.copyWith(minPrice: 0, maxPrice: 0),
                      );
                    }
                  },
                  selectedColor: Colors.green,
                  checkmarkColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Paid'),
                  selected: filter.minPrice == null && filter.maxPrice == null
                      ? false
                      : filter.minPrice != 0 || filter.maxPrice != 0,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(
                        filter.copyWith(minPrice: 0.01, maxPrice: null),
                      );
                    } else {
                      onFilterChanged(
                        filter.copyWith(minPrice: null, maxPrice: null),
                      );
                    }
                  },
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort By
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'newest',
                label: Text('Newest'),
                icon: Icon(Icons.new_releases, size: 18),
              ),
              ButtonSegment(
                value: 'popular',
                label: Text('Popular'),
                icon: Icon(Icons.trending_up, size: 18),
              ),
              ButtonSegment(
                value: 'rating',
                label: Text('Rating'),
                icon: Icon(Icons.star, size: 18),
              ),
              ButtonSegment(
                value: 'price_low',
                label: Text('Price'),
                icon: Icon(Icons.attach_money, size: 18),
              ),
            ],
            selected: {filter.sortBy ?? 'newest'},
            onSelectionChanged: (Set<String> selection) {
              onFilterChanged(
                filter.copyWith(sortBy: selection.first),
              );
            },
          ),

          // Active filters summary
          if (filter.hasActiveFilters) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getFilterSummary(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getFilterSummary() {
    final parts = <String>[];

    if (filter.categoryId != null) {
      final category = categories.firstWhere(
        (cat) => cat.id == filter.categoryId,
        orElse: () => categories.first,
      );
      parts.add(category.name!);
    }

    if (filter.level != null) {
      parts.add(filter.level!);
    }

    if (filter.minPrice == 0 && filter.maxPrice == 0) {
      parts.add('Free');
    }

    if (parts.isEmpty) {
      return 'Filters applied';
    }

    return 'Filtered by: ${parts.join(', ')}';
  }
}
