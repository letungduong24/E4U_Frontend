import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/feature/schedule/data/model/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDataSource _dataSource;

  ScheduleRepositoryImpl(this._dataSource);

  @override
  Future<List<ScheduleEntity>> getMySchedule(String day, String? token) async {
    final models = await _dataSource.getMySchedule(day, token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<ScheduleEntity>> getAllSchedules(String? token) async {
    final models = await _dataSource.getAllSchedules(token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<ScheduleEntity> getScheduleById(String scheduleId, String? token) async {
    final model = await _dataSource.getScheduleById(scheduleId, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<ScheduleEntity> createSchedule(Map<String, dynamic> scheduleData, String? token) async {
    final model = await _dataSource.createSchedule(scheduleData, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<ScheduleEntity> updateSchedule(String scheduleId, Map<String, dynamic> updates, String? token) async {
    final model = await _dataSource.updateSchedule(scheduleId, updates, token);
    return _mapModelToEntity(model);
  }

  @override
  Future<bool> deleteSchedule(String scheduleId, String? token) async {
    return await _dataSource.deleteSchedule(scheduleId, token);
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByClass(String classCode, String? token) async {
    final models = await _dataSource.getSchedulesByClass(classCode, token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByTeacher(String teacherId, String? token) async {
    final models = await _dataSource.getSchedulesByTeacher(teacherId, token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<ScheduleEntity>> getSchedulesByDate(String day, String? token) async {
    final models = await _dataSource.getSchedulesByDate(day, token);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  // Helper method to map model to entity
  ScheduleEntity _mapModelToEntity(ScheduleModel model) {
    return ScheduleEntity(
      id: model.id,
      classCode: model.classCode ?? model.className ?? '',
      className: model.className,
      subject: model.subject,
      teacherId: model.teacherId,
      teacherName: model.teacherName,
      startTime: model.startTime,
      endTime: model.endTime,
      dayOfWeek: model.dayOfWeek,
      room: model.room,
      description: model.description,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
