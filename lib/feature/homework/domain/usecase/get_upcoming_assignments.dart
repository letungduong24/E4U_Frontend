import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class GetUpcomingAssignments {
  final HomeworkRepository _repository;

  GetUpcomingAssignments(this._repository);

  Future<List<HomeworkEntity>> call(String? token) async {
    return await _repository.getUpcomingAssignments(token);
  }
}
