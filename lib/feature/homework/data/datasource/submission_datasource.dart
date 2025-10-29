import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/homework/data/model/submission_model.dart';

class SubmissionDatasource {
  final Dio _dio = DioClient().dio;

  Future<List<SubmissionModel>> getStudentSubmissions({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      print('Making API call to /submissions/student with params: $queryParams');
      final response = await _dio.get('/submissions/student', queryParameters: queryParams);

      print('API Response status: ${response.statusCode}');

      List<dynamic> submissionsJson;
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      } else {
        submissionsJson = [];
      }

      print('Found ${submissionsJson.length} submissions');

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          print('Parsing submission JSON: $json');
          final submission = SubmissionModel.fromJson(json);
          print('Parsed submission - Student name: ${submission.student.name}');
          submissions.add(submission);
        } catch (e) {
          print('Error parsing submission: $e');
          print('JSON data: $json');
        }
      }

      return submissions;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Lấy danh sách bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Lấy danh sách bài nộp thất bại');
    }
  }

  Future<SubmissionModel> getSubmissionById(String submissionId) async {
    try {
      final response = await _dio.get('/submissions/$submissionId');
      
      print('API Response status: ${response.statusCode}');

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
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Lấy thông tin bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Lấy thông tin bài nộp thất bại');
    }
  }

  Future<List<SubmissionModel>> getSubmissionsByHomeworkId(String homeworkId) async {
    try {
      print('Making API call to /submissions/homework/$homeworkId/teacher');
      final response = await _dio.get('/submissions/homework/$homeworkId/teacher');

      print('API Response status: ${response.statusCode}');

      List<dynamic> submissionsJson = [];
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      }

      print('Found ${submissionsJson.length} submissions');

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          print('Parsing submission JSON: $json');
          final submission = SubmissionModel.fromJson(json);
          print('Parsed submission - Student name: ${submission.student.name}');
          submissions.add(submission);
        } catch (e) {
          print('Error parsing submission: $e');
          print('JSON data: $json');
        }
      }

      return submissions;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Lấy danh sách bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Lấy danh sách bài nộp thất bại');
    }
  }

  Future<SubmissionModel?> getStudentSubmissionByHomeworkId(String homeworkId) async {
    try {
      print('Making API call to /submissions/homework/$homeworkId/student');
      final response = await _dio.get('/submissions/homework/$homeworkId/student');

      print('API Response status: ${response.statusCode}');

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
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Lấy thông tin bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Lấy thông tin bài nộp thất bại');
    }
  }

  Future<SubmissionModel> submitHomework({
    required String homeworkId,
    required String file,
  }) async {
    try {
      print('Making API call to POST /submissions');
      final response = await _dio.post('/submissions', data: {
        'homeworkId': homeworkId,
        'file': file,
      });

      print('API Response status: ${response.statusCode}');

      Map<String, dynamic> submissionJson;
      if (response.data['data'] is Map && response.data['data']['submission'] != null) {
        submissionJson = response.data['data']['submission'] as Map<String, dynamic>;
      } else {
        submissionJson = response.data['data'] as Map<String, dynamic>;
      }

      return SubmissionModel.fromJson(submissionJson);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Nộp bài thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Nộp bài thất bại');
    }
  }

  Future<SubmissionModel> updateSubmission({
    required String submissionId,
    required String file,
  }) async {
    try {
      print('Making API call to PUT /submissions/$submissionId');
      final response = await _dio.put('/submissions/$submissionId', data: {
        'file': file,
      });

      print('API Response status: ${response.statusCode}');

      Map<String, dynamic> submissionJson;
      if (response.data['data'] is Map && response.data['data']['submission'] != null) {
        submissionJson = response.data['data']['submission'] as Map<String, dynamic>;
      } else {
        submissionJson = response.data['data'] as Map<String, dynamic>;
      }

      return SubmissionModel.fromJson(submissionJson);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Cập nhật bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Cập nhật bài nộp thất bại');
    }
  }

  Future<void> deleteSubmission(String submissionId) async {
    try {
      print('Making API call to DELETE /submissions/$submissionId');
      final response = await _dio.delete('/submissions/$submissionId');

      print('API Response status: ${response.statusCode}');
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Xóa bài nộp thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Xóa bài nộp thất bại');
    }
  }

  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  }) async {
    try {
      print('Making API call to POST /submissions/$submissionId/grade');
      final response = await _dio.post('/submissions/$submissionId/grade', data: {
        'grade': grade,
        'feedback': feedback,
      });

      print('API Response status: ${response.statusCode}');
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Chấm bài thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Chấm bài thất bại');
    }
  }

  Future<List<SubmissionModel>> getGradedSubmissions() async {
    try {
      print('Making API call to GET /submissions/student/graded');
      final response = await _dio.get('/submissions/student/graded');

      print('API Response status: ${response.statusCode}');

      List<dynamic> submissionsJson = [];
      if (response.data['data'] is Map && response.data['data']['submissions'] is List) {
        submissionsJson = response.data['data']['submissions'];
      } else if (response.data['submissions'] is List) {
        submissionsJson = response.data['submissions'];
      }

      print('Found ${submissionsJson.length} graded submissions');

      final submissions = <SubmissionModel>[];
      for (var json in submissionsJson) {
        try {
          print('Parsing submission JSON: $json');
          final submission = SubmissionModel.fromJson(json);
          print('Parsed submission - Student name: ${submission.student.name}');
          submissions.add(submission);
        } catch (e) {
          print('Error parsing submission: $e');
          print('JSON data: $json');
        }
      }

      return submissions;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Lấy danh sách bài đã chấm thất bại');
    } catch (e) {
      print('General error: $e');
      throw Exception('Lấy danh sách bài đã chấm thất bại');
    }
  }
}

