import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class UpdateHomework {
  final HomeworkRepository _repository;

  UpdateHomework(this._repository);

  Future<HomeworkEntity> call(String homeworkId, Map<String, dynamic> updates, String? token) async {
    return await _repository.updateHomework(homeworkId, updates, token);
  }
}
