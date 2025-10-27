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
}

