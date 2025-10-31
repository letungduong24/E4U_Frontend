import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/feature/schedule/data/model/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDataSource _dataSource;

  ScheduleRepositoryImpl(this._dataSource);

  @override
  Future<List<ScheduleEntity>> getMySchedule(String day) async {
    final models = await _dataSource.getMySchedule(day);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<ScheduleEntity>> getAllSchedules() async {
    final models = await _dataSource.getAllSchedules();
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<ScheduleEntity> getScheduleById(String scheduleId) async {
    final model = await _dataSource.getScheduleById(scheduleId);
    return _mapModelToEntity(model);
  }

  @override
  Future<ScheduleEntity> createSchedule(Map<String, dynamic> scheduleData) async {
    final model = await _dataSource.createSchedule(scheduleData);
    return _mapModelToEntity(model);
  }

  @override
  Future<ScheduleEntity> updateSchedule(String scheduleId, Map<String, dynamic> updates) async {
    final model = await _dataSource.updateSchedule(scheduleId, updates);
    return _mapModelToEntity(model);
  }

  @override
  Future<bool> deleteSchedule(String scheduleId) async {
    return await _dataSource.deleteSchedule(scheduleId);
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByClass(String classCode) async {
    final models = await _dataSource.getSchedulesByClass(classCode);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByTeacher(String teacherId) async {
    final models = await _dataSource.getSchedulesByTeacher(teacherId);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<ScheduleEntity>> getSchedulesByDate(String day) async {
    final models = await _dataSource.getSchedulesByDate(day);
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
