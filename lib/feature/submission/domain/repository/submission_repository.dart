import 'package:e4uflutter/feature/submission/domain/entity/submission_entity.dart';

abstract class SubmissionRepository {
  Future<List<SubmissionEntity>> getStudentSubmissions({String? status});
  Future<SubmissionEntity> getSubmissionById(String submissionId);
}

