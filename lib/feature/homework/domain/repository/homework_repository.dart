import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';

abstract class HomeworkRepository {
  Future<List<HomeworkEntity>> getAllHomeworks({
    String? searchQuery,//searchQuery: tìm bài tập theo từ khóa (ví dụ tìm “Math”).
    String? classFilter,
    String? sortBy,
    String? sortOrder,
  });

  Future<HomeworkEntity> createHomework({
    required String title,
    required String description,
    required DateTime deadline,
    String? filePath,
  });

  Future<HomeworkEntity> updateHomework(
    String homeworkId, {
    String? title,
    String? description,
    DateTime? deadline,
    String? filePath,
  });

  Future<void> deleteHomework(String homeworkId);

  Future<List<Map<String, dynamic>>> getClasses();
}

