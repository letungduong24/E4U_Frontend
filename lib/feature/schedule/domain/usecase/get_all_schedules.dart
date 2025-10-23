import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/repository/schedule_repository.dart';

class GetAllSchedules {
  final ScheduleRepository _repository;

  GetAllSchedules(this._repository);

  Future<List<ScheduleEntity>> call(String? token) async {
    return await _repository.getAllSchedules(token);
  }
}
