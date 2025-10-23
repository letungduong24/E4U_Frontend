import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';

class UpdateSchedule {
  final ScheduleRepository _repository;

  UpdateSchedule(this._repository);

  Future<ScheduleEntity> call(String scheduleId, Map<String, dynamic> updates, String? token) async {
    return await _repository.updateSchedule(scheduleId, updates, token);
  }
}
