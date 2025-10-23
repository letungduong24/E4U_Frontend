import 'package:e4uflutter/feature/homework/domain/repository/homework_repository.dart';

class DeleteHomework {
  final HomeworkRepository _repository;

  DeleteHomework(this._repository);

  Future<bool> call(String homeworkId, String? token) async {
    return await _repository.deleteHomework(homeworkId, token);
  }
}
