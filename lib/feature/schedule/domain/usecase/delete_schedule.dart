import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';

class DeleteSchedule {
  final ScheduleRepository _repository;

  DeleteSchedule(this._repository);

  Future<bool> call(String scheduleId, String? token) async {
    return await _repository.deleteSchedule(scheduleId, token);
  }
}
