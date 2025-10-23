import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';

class CreateSchedule {
  final ScheduleRepository _repository;

  CreateSchedule(this._repository);

  Future<ScheduleEntity> call(Map<String, dynamic> scheduleData, String? token) async {
    return await _repository.createSchedule(scheduleData, token);
  }
}
