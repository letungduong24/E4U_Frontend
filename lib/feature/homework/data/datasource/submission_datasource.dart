import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/homework/data/model/submission_model.dart';

class SubmissionDatasource {
  final Dio _dio = DioClient().dio;
  //xem ds bai nop cua hs
  Future<List<SubmissionModel>> getStudentSubmissions({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dio.get('/submissions/student', queryParameters: queryParams);

      List<dynamic> submissionsJson;
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      } else {
        submissionsJson = [];
      }

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          final submission = SubmissionModel.fromJson(json);
          submissions.add(submission);
        } catch (e) {
          // Skip invalid submissions
        }
      }

      return submissions;
    } on DioException catch (e) {
      throw Exception('Lấy danh sách bài nộp thất bại');
    } catch (e) {
      throw Exception('Lấy danh sách bài nộp thất bại');
    }
  }
  //xem chi tiet btvn cu the
  Future<SubmissionModel> getSubmissionById(String submissionId) async {
    try {
      final response = await _dio.get('/submissions/$submissionId');

      Map<String, dynamic> submissionJson;
      if (response.data['data'] is Map) {
        submissionJson = response.data['data'];
        if (submissionJson['submission'] is Map) {
          submissionJson = submissionJson['submission'];
        }
      } else {
        submissionJson = response.data;
        if (submissionJson['submission'] is Map) {
          submissionJson = submissionJson['submission'];
        }
      }

      return SubmissionModel.fromJson(submissionJson);
    } on DioException catch (e) {
      throw Exception('Lấy thông tin bài nộp thất bại');
    } catch (e) {
      throw Exception('Lấy thông tin bài nộp thất bại');
    }
  }

  Future<List<SubmissionModel>> getSubmissionsByHomeworkId(String homeworkId) async {
    try {
      final response = await _dio.get('/submissions/homework/$homeworkId/teacher');

      List<dynamic> submissionsJson = [];
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      }

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          final submission = SubmissionModel.fromJson(json);
          submissions.add(submission);
        } catch (e) {
          // Skip invalid submissions
        }
      }

      return submissions;
    } on DioException catch (e) {
      throw Exception('Lấy danh sách bài nộp thất bại');
    } catch (e) {
      throw Exception('Lấy danh sách bài nộp thất bại');
    }
  }
  //xembafaif tập về nhà
  Future<SubmissionModel?> getStudentSubmissionByHomeworkId(String homeworkId) async {
    try {
      final response = await _dio.get('/submissions/homework/$homeworkId/student');

      Map<String, dynamic>? submissionJson;
      if (response.data['data'] is Map && response.data['data']['submission'] != null) {
        submissionJson = response.data['data']['submission'] as Map<String, dynamic>;
      }

      if (submissionJson != null) {
        return SubmissionModel.fromJson(submissionJson);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // No submission found
        return null;
      }
      throw Exception('Lấy thông tin bài nộp thất bại');
    } catch (e) {
      throw Exception('Lấy thông tin bài nộp thất bại');
    }
  }

  Future<SubmissionModel> submitHomework({
    required String homeworkId,
    required String file,
  }) async {
    try {
      final response = await _dio.post('/submissions', data: {
        'homeworkId': homeworkId,
        'file': file,
      });

      Map<String, dynamic> submissionJson;
      if (response.data['data'] is Map && response.data['data']['submission'] != null) {
        submissionJson = response.data['data']['submission'] as Map<String, dynamic>;
      } else {
        submissionJson = response.data['data'] as Map<String, dynamic>;
      }

      return SubmissionModel.fromJson(submissionJson);
    } on DioException catch (e) {
      throw Exception('Nộp bài thất bại');
    } catch (e) {
      throw Exception('Nộp bài thất bại');
    }
  }

  Future<SubmissionModel> updateSubmission({
    required String submissionId,
    required String file,
  }) async {
    try {
      final response = await _dio.put('/submissions/$submissionId', data: {
        'file': file,
      });

      Map<String, dynamic> submissionJson;
      if (response.data['data'] is Map && response.data['data']['submission'] != null) {
        submissionJson = response.data['data']['submission'] as Map<String, dynamic>;
      } else {
        submissionJson = response.data['data'] as Map<String, dynamic>;
      }

      return SubmissionModel.fromJson(submissionJson);
    } on DioException catch (e) {
      throw Exception('Cập nhật bài nộp thất bại');
    } catch (e) {
      throw Exception('Cập nhật bài nộp thất bại');
    }
  }

  Future<void> deleteSubmission(String submissionId) async {
    try {
      await _dio.delete('/submissions/$submissionId');
    } on DioException catch (e) {
      throw Exception('Xóa bài nộp thất bại');
    } catch (e) {
      throw Exception('Xóa bài nộp thất bại');
    }
  }

  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  }) async {
    try {
      await _dio.post('/submissions/$submissionId/grade', data: {
        'grade': grade,
        'feedback': feedback,
      });
    } on DioException catch (e) {
      throw Exception('Chấm bài thất bại');
    } catch (e) {
      throw Exception('Chấm bài thất bại');
    }
  }
  //xem ds bài đc chấm
  Future<List<SubmissionModel>> getGradedSubmissions() async {
    try {
      final response = await _dio.get('/submissions/student/graded');

      List<dynamic> submissionsJson = [];
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      }

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          final submission = SubmissionModel.fromJson(json);
          submissions.add(submission);
        } catch (e) {
          // Skip invalid submissions
        }
      }

      return submissions;
    } on DioException catch (e) {
      throw Exception('Lấy danh sách bài đã chấm thất bại');
    } catch (e) {
      throw Exception('Lấy danh sách bài đã chấm thất bại');
    }
  }
}

