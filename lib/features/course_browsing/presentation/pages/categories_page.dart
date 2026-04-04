// File: lib/features/course_browsing/presentation/pages/categories_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';

/// Categories Page
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(const LoadCategoriesEvent());
  }

  void _onCategoryTap(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    // Navigate to courses with filter
    context.go('/courses?category=$categoryId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Categories'),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseError) {
            return _buildErrorView(state.message);
          }

          if (state is CourseEmpty) {
            return _buildEmptyView(state.message);
          }

          if (state is CategoriesLoaded) {
            return _buildCategoriesGrid(state.categories);
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(List categories) {
    if (categories.isEmpty) {
      return _buildEmptyView('No categories available');
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CourseBloc>().add(const LoadCategoriesEvent());
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    final isSelected = _selectedCategoryId == category.id;

    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(
                color: category.color != null
                    ? Color(int.parse('0xFF${category.color!.substring(1)}'))
                    : Theme.of(context).primaryColor,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _onCategoryTap(category.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: category.color != null
                  ? [
                      Color(int.parse('0xFF${category.color!.substring(1)}'))
                          .withValues(alpha: 0.8),
                      Color(int.parse('0xFF${category.color!.substring(1)}'))
                          .withValues(alpha: 0.6),
                    ]
                  : [
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon and name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    if (category.hasIcon)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconData(category.icon),
                          size: 28,
                          color: category.color != null
                              ? Color(int.parse(
                                  '0xFF${category.color!.substring(1)}'))
                              : Theme.of(context).primaryColor,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 28,
                          color: category.color != null
                              ? Color(int.parse(
                                  '0xFF${category.color!.substring(1)}'))
                              : Theme.of(context).primaryColor,
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description
                    if (category.description != null &&
                        category.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        category.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),

                // Course count badge
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school,
                          size: 14,
                          color: category.color != null
                              ? Color(int.parse(
                                  '0xFF${category.color!.substring(1)}'))
                              : Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${category.courseCount}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: category.color != null
                                    ? Color(int.parse(
                                        '0xFF${category.color!.substring(1)}'))
                                    : Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.category;

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

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CourseBloc>().add(const LoadCategoriesEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
