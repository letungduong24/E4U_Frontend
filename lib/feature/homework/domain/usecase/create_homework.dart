import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class CreateHomework {
  final HomeworkRepository _repository;

  CreateHomework(this._repository);

  Future<HomeworkEntity> call(Map<String, dynamic> homeworkData, String? token) async {
    return await _repository.createHomework(homeworkData, token);
  }
}
