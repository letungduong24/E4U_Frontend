import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/model/class_management_model.dart';

class ClassManagementDatasource {
  final Dio _dio = DioClient().dio;

  Future<List<ClassManagementModel>> getAllClasses({
    String? teacher,
    String? searchQuery,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      print('Filter parameters received:');
      print('- teacher: $teacher');
      print('- searchQuery: $searchQuery');
      
      if (teacher != null && teacher.isNotEmpty) {
        queryParams['teacher'] = teacher;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      
      print('Making API call to /classes with params: $queryParams');
      final response = await _dio.get('/classes', queryParameters: queryParams);
      
      // Debug logging
      print('API Response status: ${response.statusCode}');
      print('API Response data: ${response.data}');
      
      // Handle API response structure: data.classes
      List<dynamic> classesJson;
      if (response.data['data'] != null && response.data['data']['classes'] != null) {
        classesJson = response.data['data']['classes'];
        print('Found ${classesJson.length} classes in data.classes');
      } else if (response.data['data'] != null && response.data['data']['items'] != null) {
        classesJson = response.data['data']['items'];
        print('Found ${classesJson.length} classes in data.items');
      } else if (response.data['data'] is List) {
        classesJson = response.data['data'];
        print('Found ${classesJson.length} classes in data (array)');
      } else {
        classesJson = [];
        print('No classes found in response');
        print('Response structure: ${response.data.keys}');
      }
      
      final allClasses = <ClassManagementModel>[];
      for (int i = 0; i < classesJson.length; i++) {
        try {
          print('Parsing class $i: ${classesJson[i]}');
          final classItem = ClassManagementModel.fromJson(classesJson[i]);
          allClasses.add(classItem);
          print('Successfully parsed class: ${classItem.name}');
        } catch (e) {
          print('Error parsing class $i: $e');
          print('Class data: ${classesJson[i]}');
          // Skip this class and continue with others
        }
      }
      print('Successfully parsed ${allClasses.length} classes from API');
      print('Classes before filtering:');
      for (var classItem in allClasses) {
        print('- ${classItem.name} (${classItem.code}) - Teacher: ${classItem.homeroomTeacherName}');
      }
      
      // Apply frontend filtering and sorting
      var filteredClasses = allClasses;
      
      // Filter by teacher
      if (teacher != null && teacher.isNotEmpty) {
        filteredClasses = filteredClasses.where((classItem) => 
          classItem.homeroomTeacherId == teacher || 
          classItem.homeroomTeacherName?.toLowerCase().contains(teacher.toLowerCase()) == true
        ).toList();
        print('Filtered by teacher $teacher: ${filteredClasses.length} classes');
      }
      
      // Filter by search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredClasses = filteredClasses.where((classItem) => 
          classItem.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          classItem.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          classItem.description.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
        print('Filtered by search "$searchQuery": ${filteredClasses.length} classes');
      }
      
      // Filter by active status
      if (isActive != null) {
        filteredClasses = filteredClasses.where((classItem) => classItem.isActive == isActive).toList();
        print('Filtered by isActive $isActive: ${filteredClasses.length} classes');
      }
      
      // Sort classes
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'createdAt') {
          if (sortOrder == 'desc') {
            filteredClasses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          } else {
            filteredClasses.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
        } else if (sortBy == 'name') {
          if (sortOrder == 'desc') {
            filteredClasses.sort((a, b) => b.name.compareTo(a.name));
          } else {
            filteredClasses.sort((a, b) => a.name.compareTo(b.name));
          }
        } else if (sortBy == 'code') {
          if (sortOrder == 'desc') {
            filteredClasses.sort((a, b) => b.code.compareTo(a.code));
          } else {
            filteredClasses.sort((a, b) => a.code.compareTo(b.code));
          }
        }
        print('Sorted by $sortBy $sortOrder');
      }
      
      print('Final result: ${filteredClasses.length} classes');
      print('Final classes:');
      for (var classItem in filteredClasses) {
        print('- ${classItem.name} (${classItem.code})');
      }
      print('Returning ${filteredClasses.length} classes from API (not mock)');
      return filteredClasses;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request method: ${e.requestOptions.method}');
      
      // Fallback to mock data if API fails
      print('API failed, using mock data');
      return _getMockClasses();
    } catch (e) {
      print('General error: $e');
      print('Stack trace: ${StackTrace.current}');
      // Fallback to mock data if any error
      print('Error occurred, using mock data');
      return _getMockClasses();
    }
  }

  List<ClassManagementModel> _getMockClasses() {
    final now = DateTime.now();
    return [
      ClassManagementModel(
        id: '1',
        name: 'IELTS Foundation - Band 4.0-5.5',
        code: 'IELTS-FOUNDATION',
        description: 'Lớp IELTS Foundation dành cho học viên mới bắt đầu, mục tiêu đạt band 4.0-5.5',
        homeroomTeacherId: 'teacher1',
        homeroomTeacherName: 'Nguyễn Văn A',
        studentIds: ['student1', 'student2', 'student3'],
        enrollmentIds: ['enrollment1', 'enrollment2'],
        maxStudents: 30,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ClassManagementModel(
        id: '2',
        name: 'IELTS Advanced - Band 6.0-7.5',
        code: 'IELTS-ADVANCED',
        description: 'Lớp IELTS Advanced dành cho học viên có nền tảng, mục tiêu đạt band 6.0-7.5',
        homeroomTeacherId: 'teacher2',
        homeroomTeacherName: 'Trần Thị B',
        studentIds: ['student4', 'student5'],
        enrollmentIds: ['enrollment3', 'enrollment4'],
        maxStudents: 25,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ClassManagementModel(
        id: '3',
        name: 'TOEIC Preparation',
        code: 'TOEIC-PREP',
        description: 'Lớp luyện thi TOEIC từ cơ bản đến nâng cao',
        homeroomTeacherId: 'teacher3',
        homeroomTeacherName: 'Lê Văn C',
        studentIds: ['student6', 'student7', 'student8', 'student9'],
        enrollmentIds: ['enrollment5', 'enrollment6'],
        maxStudents: 35,
        isActive: false,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ClassManagementModel(
        id: '4',
        name: 'English Conversation',
        code: 'CONVERSATION',
        description: 'Lớp giao tiếp tiếng Anh thực tế',
        homeroomTeacherId: 'teacher1',
        homeroomTeacherName: 'Nguyễn Văn A',
        studentIds: ['student10'],
        enrollmentIds: ['enrollment7'],
        maxStudents: 20,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }

  Future<ClassManagementModel> getClassById(String classId) async {
    try {
      final response = await _dio.get('/classes/$classId');
      return ClassManagementModel.fromJson(response.data['data']['class']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy thông tin lớp học thất bại');
    }
  }

  Future<ClassManagementModel> createClass({
    required String name,
    required String code,
    required String homeroomTeacherId,
    String? description,
    int? maxStudents,
  }) async {
    try {
      final requestData = {
        'name': name,
        'code': code,
        'description': description ?? '',
        'maxStudents': maxStudents ?? 30,
      };

      print('Creating class with data: $requestData');
      final response = await _dio.post('/classes', data: requestData);
      
      print('Create class response: ${response.data}');
      return ClassManagementModel.fromJson(response.data['data']['class']);
    } on DioException catch (e) {
      print('Error creating class: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Tạo lớp học thất bại');
    }
  }

  Future<ClassManagementModel> updateClass(String classId, {
    String? name,
    String? code,
    String? homeroomTeacherId,
    String? description,
    int? maxStudents,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (code != null) data['code'] = code;
      if (homeroomTeacherId != null) data['homeroomTeacher'] = homeroomTeacherId;
      if (description != null) data['description'] = description;
      if (maxStudents != null) data['maxStudents'] = maxStudents;
      if (isActive != null) data['isActive'] = isActive;

      final response = await _dio.put(
        '/classes/$classId', 
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return ClassManagementModel.fromJson(response.data['data']['class']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Cập nhật lớp học thất bại');
    } catch (e) {
      print('General error in updateClass: $e');
      throw Exception('Cập nhật lớp học thất bại: $e');
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      await _dio.delete('/classes/$classId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa lớp học thất bại');
    }
  }

  Future<void> toggleClassStatus(String classId, bool isActive) async {
    try {
      await _dio.patch('/classes/$classId/active', data: {'isActive': isActive});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Thay đổi trạng thái lớp học thất bại');
    }
  }

}
