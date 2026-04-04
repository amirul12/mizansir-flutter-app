// File: lib/features/course_browsing/domain/entities/course_filter.dart
import 'package:equatable/equatable.dart';

/// Course Filter entity
class CourseFilter extends Equatable {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? level;
  final String? status;
  final String? sortBy; // newest, price_low, price_high, popularity, rating
  final String? searchQuery;

  const CourseFilter({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.level,
    this.status,
    this.sortBy,
    this.searchQuery,
  });

  /// Check if filter has any active filters
  bool get hasActiveFilters =>
      categoryId != null ||
      minPrice != null ||
      maxPrice != null ||
      level != null ||
      status != null ||
      searchQuery != null;

  /// Check if filtering by category
  bool get hasCategoryFilter => categoryId != null;

  /// Check if filtering by price
  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  /// Check if filtering by level
  bool get hasLevelFilter => level != null;

  /// Check if searching
  bool get isSearching => searchQuery != null && searchQuery!.isNotEmpty;

  /// Create empty filter
  const CourseFilter.empty()
      : categoryId = null,
        minPrice = null,
        maxPrice = null,
        level = null,
        status = null,
        sortBy = null,
        searchQuery = null;

  /// Create copy with method
  CourseFilter copyWith({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? level,
    String? status,
    String? sortBy,
    String? searchQuery,
  }) {
    return CourseFilter(
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      level: level ?? this.level,
      status: status ?? this.status,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Clear all filters
  CourseFilter clear() {
    return const CourseFilter.empty();
  }

  /// Convert to query parameters
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (categoryId != null) params['category_id'] = categoryId;
    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (level != null) params['level'] = level;
    if (status != null) params['status'] = status;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (searchQuery != null) params['q'] = searchQuery;

    return params;
  }

  @override
  List<Object?> get props => [
        categoryId,
        minPrice,
        maxPrice,
        level,
        status,
        sortBy,
        searchQuery,
      ];
}
