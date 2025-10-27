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
      
      print('==========================================');
      print('GET /homeworks - Starting request');
      print('Query params: $queryParams');
      print('==========================================');
      
      final response = await _dio.get('/homeworks', queryParameters: queryParams);
      
      print('==========================================');
      print('GET /homeworks - Response received');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('==========================================');
      
      List<dynamic> homeworksJson;
      // Check if response has data.homeworks (new structure)
      if (response.data['data'] is Map && response.data['data']['homeworks'] is List) {
        homeworksJson = response.data['data']['homeworks'];
        print('✓ Found ${homeworksJson.length} homeworks in data.homeworks');
        
        // Log pagination if available
        if (response.data['data']['pagination'] != null) {
          final pagination = response.data['data']['pagination'];
          print('Pagination: page ${pagination['page']}/${pagination['pages']}, total: ${pagination['total']}');
        }
      } else if (response.data['data'] is List) {
        // Fallback for old structure (direct array)
        homeworksJson = response.data['data'];
        print('✓ Found ${homeworksJson.length} homeworks in data array (old structure)');
      } else {
        homeworksJson = [];
        print('✗ No homeworks found in response');
      }
      
      final allHomeworks = <HomeworkModel>[];
      for (int i = 0; i < homeworksJson.length; i++) {
        try {
          print('--- Parsing homework $i ---');
          print('Raw data: ${homeworksJson[i]}');
          final homework = HomeworkModel.fromJson(homeworksJson[i]);
          allHomeworks.add(homework);
          print('✓ Successfully parsed: ${homework.title}');
        } catch (e, stackTrace) {
          print('✗ Error parsing homework $i');
          print('Error: $e');
          print('Stack trace: $stackTrace');
          print('Data: ${homeworksJson[i]}');
        }
      }
      
      if (sortBy != null && sortBy.isNotEmpty) {
        print('Sorting homeworks by $sortBy ($sortOrder)');
        if (sortBy == 'deadline') {
          if (sortOrder == 'desc') {
            allHomeworks.sort((a, b) => b.deadline.compareTo(a.deadline));
          } else {
            allHomeworks.sort((a, b) => a.deadline.compareTo(b.deadline));
          }
        }
      }
      
      print('✓ Returning ${allHomeworks.length} homeworks');
      print('==========================================');
      return allHomeworks;
    } on DioException catch (e) {
      print('==========================================');
      print('✗ GET /homeworks - DioException');
      print('Error: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('==========================================');
      throw Exception(e.response?.data['message'] ?? 'Lấy danh sách bài tập thất bại');
    } catch (e, stackTrace) {
      print('==========================================');
      print('✗ GET /homeworks - General exception');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('==========================================');
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

      print('==========================================');
      print('POST /homeworks - Creating homework');
      print('Request data: $requestData');
      print('Title: $title');
      print('Description: $description');
      print('Deadline: ${deadline.toIso8601String()}');
      print('File path: ${filePath ?? "N/A"}');
      print('==========================================');
      
      final response = await _dio.post('/homeworks', data: requestData);
      
      print('==========================================');
      print('POST /homeworks - Response received');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('==========================================');
      
      // Check response structure
      if (response.data['data'] == null) {
        print('✗ ERROR: response.data is null');
        throw Exception('Invalid response structure');
      }
      
      if (response.data['data']['homework'] == null) {
        print('✗ ERROR: response.data.homework is null');
        throw Exception('Invalid response structure: homework data is null');
      }
      
      print('✓ Parsing homework from response...');
      final homework = HomeworkModel.fromJson(response.data['data']['homework']);
      print('✓ Successfully created homework: ${homework.title}');
      print('==========================================');
      
      return homework;
    } on DioException catch (e) {
      print('==========================================');
      print('✗ POST /homeworks - DioException');
      print('Error message: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Headers: ${e.response?.headers}');
      print('==========================================');
      
      // Check if it's a validation error
      if (e.response?.statusCode == 400) {
        print('✗ Validation error detected');
        final errorData = e.response?.data;
        if (errorData != null) {
          print('Error details: $errorData');
          if (errorData['errors'] != null) {
            print('Validation errors: ${errorData['errors']}');
            throw Exception('Thông tin không hợp lệ');
          }
        }
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Tạo bài tập thất bại';
      throw Exception(message);
    } catch (e, stackTrace) {
      print('==========================================');
      print('✗ POST /homeworks - General exception');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('==========================================');
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

      print('==========================================');
      print('PUT /homeworks/$homeworkId - Updating homework');
      print('Request data: $data');
      print('==========================================');
      
      final response = await _dio.put('/homeworks/$homeworkId', data: data);
      
      print('==========================================');
      print('PUT /homeworks/$homeworkId - Response received');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('==========================================');
      
      return HomeworkModel.fromJson(response.data['data']['homework']);
    } on DioException catch (e) {
      print('==========================================');
      print('✗ PUT /homeworks/$homeworkId - DioException');
      print('Error message: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('==========================================');
      
      // Check if it's a validation error
      if (e.response?.statusCode == 400) {
        print('✗ Validation error detected');
        final errorData = e.response?.data;
        if (errorData != null) {
          print('Error details: $errorData');
          if (errorData['errors'] != null) {
            print('Validation errors: ${errorData['errors']}');
            throw Exception('Thông tin không hợp lệ');
          }
        }
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Cập nhật bài tập thất bại';
      throw Exception(message);
    } catch (e, stackTrace) {
      print('==========================================');
      print('✗ PUT /homeworks/$homeworkId - General exception');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('==========================================');
      throw Exception('Cập nhật bài tập thất bại: $e');
    }
  }

  Future<void> deleteHomework(String homeworkId) async {
    try {
      await _dio.delete('/homeworks/$homeworkId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa bài tập thất bại');
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

