// File: lib/features/course_browsing/presentation/pages/courses_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/course_filter.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_card.dart';
import '../widgets/course_filter_widget.dart';

/// Courses Page - Main course browsing page
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController _scrollController = ScrollController();
  CourseFilter? _currentFilter;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial courses
    context.read<CourseBloc>().add(const LoadCoursesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<CourseBloc>().state;
      if (state is CoursesLoaded && state.hasMore) {
        // Load more courses
        context.read<CourseBloc>().add(
          LoadCoursesEvent(
            filter: _currentFilter,
            page: (state.courses.length / 20).floor() + 1,
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _applyFilter(CourseFilter newFilter) {
    setState(() {
      _currentFilter = newFilter;
    });
    context.read<CourseBloc>().add(LoadCoursesEvent(filter: newFilter));
  }

  void _clearFilters() {
    setState(() {
      _currentFilter = null;
    });
    context.read<CourseBloc>().add(const LoadCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),

        title: const Text('Explore Courses'),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search page
              context.go('/search');
            },
          ),

          // Filter toggle
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          if (_showFilters)
            BlocBuilder<CourseBloc, CourseState>(
              buildWhen: (previous, current) =>
                  current is CategoriesLoaded || current is CourseInitial,
              builder: (context, state) {
                if (state is! CategoriesLoaded) {
                  return const SizedBox();
                }

                return CourseFilterWidget(
                  filter: _currentFilter ?? const CourseFilter(),
                  categories: state.categories,
                  onFilterChanged: _applyFilter,
                  onClearFilters: _clearFilters,
                );
              },
            ),

          // Courses list
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
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

                if (state is CoursesLoaded) {
                  return _buildCoursesList(state.courses, state.hasMore);
                }

                // Initial state - show loading
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List courses, bool hasMore) {
    if (courses.isEmpty) {
      return _buildEmptyView('No courses found');
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CourseBloc>().add(
          LoadCoursesEvent(filter: _currentFilter),
        );
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: courses.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index >= courses.length) {
            // Loading indicator for more items
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final course = courses[index];
          return CourseCard(
            course: course,
            onTap: () {
              // Navigate to course details
              context.go('/courses/${course.id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CourseBloc>().add(
                  LoadCoursesEvent(filter: _currentFilter),
                );
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
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (_currentFilter != null && _currentFilter!.hasActiveFilters) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
