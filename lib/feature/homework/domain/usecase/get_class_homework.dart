import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class GetClassHomework {
  final HomeworkRepository _repository;

  GetClassHomework(this._repository);

  Future<List<HomeworkEntity>> call(String classId, String? token) async {
    return await _repository.getClassHomework(classId, token);
  }
}
