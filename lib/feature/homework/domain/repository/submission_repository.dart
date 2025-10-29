import 'package:e4uflutter/feature/homework/domain/entity/submission_entity.dart';

abstract class SubmissionRepository {
  Future<List<SubmissionEntity>> getStudentSubmissions({String? status});
  Future<SubmissionEntity> getSubmissionById(String submissionId);
  Future<List<SubmissionEntity>> getSubmissionsByHomeworkId(String homeworkId);
  Future<SubmissionEntity?> getStudentSubmissionByHomeworkId(String homeworkId);
  Future<SubmissionEntity> submitHomework({
    required String homeworkId,
    required String file,
  });
  Future<SubmissionEntity> updateSubmission({
    required String submissionId,
    required String file,
  });

  Future<void> deleteSubmission(String submissionId);

  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  });

  Future<List<SubmissionEntity>> getGradedSubmissions();
}

