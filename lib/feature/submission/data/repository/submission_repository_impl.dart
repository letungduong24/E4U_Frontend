import 'package:e4uflutter/feature/submission/data/datasource/submission_datasource.dart';
import 'package:e4uflutter/feature/submission/data/model/submission_model.dart';
import 'package:e4uflutter/feature/submission/domain/entity/submission_entity.dart';
import 'package:e4uflutter/feature/submission/domain/repository/submission_repository.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionDatasource _datasource;

  SubmissionRepositoryImpl(this._datasource);

  @override
  Future<List<SubmissionEntity>> getStudentSubmissions({String? status}) async {
    try {
      final submissions = await _datasource.getStudentSubmissions(status: status);
      return submissions;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubmissionEntity> getSubmissionById(String submissionId) async {
    try {
      final submission = await _datasource.getSubmissionById(submissionId);
      return submission;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SubmissionEntity>> getSubmissionsByHomeworkId(String homeworkId) async {
    try {
      final submissions = await _datasource.getSubmissionsByHomeworkId(homeworkId);
      return submissions;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubmissionEntity?> getStudentSubmissionByHomeworkId(String homeworkId) async {
    try {
      final submission = await _datasource.getStudentSubmissionByHomeworkId(homeworkId);
      return submission;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubmissionEntity> submitHomework({
    required String homeworkId,
    required String file,
  }) async {
    try {
      final submission = await _datasource.submitHomework(
        homeworkId: homeworkId,
        file: file,
      );
      return submission;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubmissionEntity> updateSubmission({
    required String submissionId,
    required String file,
  }) async {
    try {
      final submission = await _datasource.updateSubmission(
        submissionId: submissionId,
        file: file,
      );
      return submission;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSubmission(String submissionId) async {
    try {
      await _datasource.deleteSubmission(submissionId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  }) async {
    try {
      await _datasource.gradeSubmission(
        submissionId: submissionId,
        grade: grade,
        feedback: feedback,
      );
    } catch (e) {
      rethrow;
    }
  }
}

