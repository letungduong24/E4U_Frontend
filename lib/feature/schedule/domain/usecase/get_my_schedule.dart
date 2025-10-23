import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';

class GetMySchedule {
  final ScheduleRepository _repository;

  GetMySchedule(this._repository);

  Future<List<ScheduleEntity>> call(String day, String? token) async {
    return await _repository.getMySchedule(day, token);
  }
}
