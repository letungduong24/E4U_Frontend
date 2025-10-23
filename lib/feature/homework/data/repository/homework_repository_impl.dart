import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';
import 'package:e4uflutter/feature/homework/data/datasource/homework_datasource.dart';
import 'package:e4uflutter/feature/homework/data/model/homework_model.dart';

class HomeworkRepositoryImpl implements HomeworkRepository {
  final HomeworkDataSource _dataSource;

  HomeworkRepositoryImpl(this._dataSource);

  @override
  Future<List<HomeworkEntity>> getUpcomingAssignments(String? token) async {
    final models = await _dataSource.getUpcomingAssignments(token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<HomeworkEntity>> getOverdueAssignments(String? token) async {
    final models = await _dataSource.getOverdueAssignments(token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<HomeworkEntity>> getAllHomework(String? token) async {
    final models = await _dataSource.getAllHomework(token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<HomeworkEntity> getHomeworkById(String homeworkId, String? token) async {
    final model = await _dataSource.getHomeworkById(homeworkId, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<List<HomeworkEntity>> getClassHomework(String classId, String? token) async {
    final models = await _dataSource.getClassHomework(classId, token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<HomeworkEntity> createHomework(Map<String, dynamic> homeworkData, String? token) async {
    final model = await _dataSource.createHomework(homeworkData, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<HomeworkEntity> updateHomework(String homeworkId, Map<String, dynamic> updates, String? token) async {
    final model = await _dataSource.updateHomework(homeworkId, updates, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<bool> deleteHomework(String homeworkId, String? token) async {
    return await _dataSource.deleteHomework(homeworkId, token);
  }

  // Helper method to map model to entity
  HomeworkEntity _mapModelToEntity(HomeworkModel model) {
    return HomeworkEntity(
      id: model.id,
      classId: model.classId,
      className: model.className,
      title: model.title,
      description: model.description,
      deadline: model.deadline,
      fileName: model.fileName,
      filePath: model.filePath,
      attachmentUrl: model.attachmentUrl,
      attachmentName: model.attachmentName,
      teacherId: model.teacherId,
      teacherName: model.teacherName,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
