import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/submission/data/model/submission_model.dart';

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
          final submission = SubmissionModel.fromJson(json);
          submissions.add(submission);
        } catch (e) {
          print('Error parsing submission: $e');
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
}

