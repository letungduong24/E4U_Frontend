import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';

abstract class HomeworkRepository {
  Future<List<HomeworkEntity>> getAllHomeworks({
    String? searchQuery,
    String? classFilter,
    String? sortBy,
    String? sortOrder,
  });

  Future<HomeworkEntity> createHomework({
    required String title,
    required String description,
    required DateTime deadline,
    String? fileName,
    String? filePath,
  });

  Future<HomeworkEntity> updateHomework(
    String homeworkId, {
    String? title,
    String? description,
    DateTime? deadline,
    String? fileName,
    String? filePath,
  });

  Future<void> deleteHomework(String homeworkId);

  Future<List<Map<String, dynamic>>> getClasses();
}

