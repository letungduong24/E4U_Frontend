import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/homework/data/model/homework_model.dart';

class HomeworkDatasource {
  final Dio _dio = DioClient().dio;

  Future<List<HomeworkModel>> getAllHomeworks({
    String? searchQuery,
    String? classFilter,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (classFilter != null && classFilter.isNotEmpty) {
        queryParams['classId'] = classFilter;
      }
      
      final response = await _dio.get('/homeworks', queryParameters: queryParams);
      
      List<dynamic> homeworksJson;
      // Check if response has data.homeworks (new structure)
      if (response.data['data'] is Map && response.data['data']['homeworks'] is List) {
        homeworksJson = response.data['data']['homeworks'];
      } else if (response.data['data'] is List) {
        // Fallback for old structure (direct array)
        homeworksJson = response.data['data'];
      } else {
        homeworksJson = [];
      }
      
      final allHomeworks = <HomeworkModel>[];
      for (int i = 0; i < homeworksJson.length; i++) {
        try {
          final homework = HomeworkModel.fromJson(homeworksJson[i]);
          allHomeworks.add(homework);
        } catch (e, stackTrace) {
          // Skip invalid homeworks
        }
      }
      
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'deadline') {
          if (sortOrder == 'desc') {
            allHomeworks.sort((a, b) => b.deadline.compareTo(a.deadline));
          } else {
            allHomeworks.sort((a, b) => a.deadline.compareTo(b.deadline));
          }
        }
      }
      
      return allHomeworks;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy danh sách bài tập thất bại');
    } catch (e, stackTrace) {
      throw Exception('Lấy danh sách bài tập thất bại: $e');
    }
  }

  Future<HomeworkModel> createHomework({
    required String title,
    required String description,
    required DateTime deadline,
    String? filePath,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'title': title,
        'description': description,
        'deadline': deadline.toIso8601String(),
      };

      if (filePath != null && filePath.isNotEmpty) {
        // If filePath is provided, get fileName from the path
        final fileName = filePath.split('/').last;
        requestData['file'] = {
          'fileName': fileName,
          'filePath': filePath,
        };
      }

      final response = await _dio.post('/homeworks', data: requestData);
      
      // Check response structure
      if (response.data['data'] == null) {
        throw Exception('Invalid response structure');
      }
      
      if (response.data['data']['homework'] == null) {
        throw Exception('Invalid response structure: homework data is null');
      }
      
      final homework = HomeworkModel.fromJson(response.data['data']['homework']);
      
      return homework;
    } on DioException catch (e) {
      // Check if it's a validation error
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null) {
          if (errorData['errors'] != null) {
            throw Exception('Thông tin không hợp lệ');
          }
        }
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Tạo bài tập thất bại';
      throw Exception(message);
    } catch (e, stackTrace) {
      throw Exception('Tạo bài tập thất bại: $e');
    }
  }

  Future<HomeworkModel> updateHomework(
    String homeworkId, {
    String? title,
    String? description,
    DateTime? deadline,
    String? filePath,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (deadline != null) data['deadline'] = deadline.toIso8601String();
      if (filePath != null && filePath.isNotEmpty) {
        final fileName = filePath.split('/').last;
        data['file'] = {'fileName': fileName, 'filePath': filePath};
      }

      final response = await _dio.put('/homeworks/$homeworkId', data: data);
      
      return HomeworkModel.fromJson(response.data['data']['homework']);
    } on DioException catch (e) {
      // Check if it's a validation error
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null) {
          if (errorData['errors'] != null) {
            throw Exception('Thông tin không hợp lệ');
          }
        }
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Cập nhật bài tập thất bại';
      throw Exception(message);
    } catch (e, stackTrace) {
      throw Exception('Cập nhật bài tập thất bại: $e');
    }
  }

  Future<void> deleteHomework(String homeworkId) async {
    try {
      await _dio.delete('/homeworks/$homeworkId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa bài tập thất bại');
    } catch (e, stackTrace) {
      throw Exception('Xóa bài tập thất bại: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      final response = await _dio.get('/classes');
      
      List<dynamic> classesJson;
      if (response.data['data'] != null && response.data['data']['classes'] != null) {
        classesJson = response.data['data']['classes'];
      } else if (response.data['data'] is List) {
        classesJson = response.data['data'];
      } else {
        classesJson = [];
      }
      
      return classesJson.map((json) => {
        'id': json['_id'],
        'name': json['name'],
        'code': json['code'],
      }).toList();
    } on DioException catch (_) {
      return [];
    } catch (_) {
      return [];
    }
  }
}

