import 'package:e4uflutter/feature/homework/data/datasource/homework_datasource.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class HomeworkRepositoryImpl implements HomeworkRepository {
  final HomeworkDatasource _datasource;

  HomeworkRepositoryImpl(this._datasource);

  @override
  Future<List<HomeworkEntity>> getAllHomeworks({
    String? searchQuery,
    String? classFilter,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await _datasource.getAllHomeworks(
      searchQuery: searchQuery,
      classFilter: classFilter,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<HomeworkEntity> createHomework({
    required String title,
    required String description,
    required DateTime deadline,
    String? fileName,
    String? filePath,
  }) async {
    return await _datasource.createHomework(
      title: title,
      description: description,
      deadline: deadline,
      fileName: fileName,
      filePath: filePath,
    );
  }

  @override
  Future<HomeworkEntity> updateHomework(
    String homeworkId, {
    String? title,
    String? description,
    DateTime? deadline,
    String? fileName,
    String? filePath,
  }) async {
    return await _datasource.updateHomework(
      homeworkId,
      title: title,
      description: description,
      deadline: deadline,
      fileName: fileName,
      filePath: filePath,
    );
  }

  @override
  Future<void> deleteHomework(String homeworkId) async {
    await _datasource.deleteHomework(homeworkId);
  }

  @override
  Future<List<Map<String, dynamic>>> getClasses() async {
    return await _datasource.getClasses();
  }
}

