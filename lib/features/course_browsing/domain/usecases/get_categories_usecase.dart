// File: lib/features/course_browsing/domain/usecases/get_categories_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/course_repository.dart';

/// Get Categories Use Case
class GetCategoriesUseCase {
  final CourseRepository repository;

  const GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call(NoParams params) {
    return repository.getCategories();
  }
}
