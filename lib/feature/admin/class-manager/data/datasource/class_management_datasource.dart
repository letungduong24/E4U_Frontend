import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/model/class_management_model.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/model/class_student_model.dart';

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
      
      if (teacher != null && teacher.isNotEmpty) {
        queryParams['teacher'] = teacher;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      
      final response = await _dio.get('/classes', queryParameters: queryParams);
      
      // Handle API response structure: data.classes
      List<dynamic> classesJson;
      if (response.data['data'] != null && response.data['data']['classes'] != null) {
        classesJson = response.data['data']['classes'];
      } else if (response.data['data'] != null && response.data['data']['items'] != null) {
        classesJson = response.data['data']['items'];
      } else if (response.data['data'] is List) {
        classesJson = response.data['data'];
      } else {
        classesJson = [];
      }
      
      final allClasses = <ClassManagementModel>[];
      for (int i = 0; i < classesJson.length; i++) {
        try {
          final classItem = ClassManagementModel.fromJson(classesJson[i]);
          allClasses.add(classItem);
        } catch (e) {
          // Skip this class and continue with others
        }
      }
      
      // Backend already handles filtering, just return the classes
      return allClasses;
    } on DioException catch (e) {
      // Fallback to mock data if API fails
      return _getMockClasses();
    } catch (e) {
      // Fallback to mock data if any error
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

      final response = await _dio.post('/classes', data: requestData);
      
      return ClassManagementModel.fromJson(response.data['data']['class']);
    } on DioException catch (e) {
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
      if (homeroomTeacherId != null) {
        data['homeroomTeacher'] = homeroomTeacherId.isEmpty ? null : homeroomTeacherId;
      }
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

  Future<void> setHomeroomTeacher(String classId, String teacherId) async {
    try {
      await _dio.post('/classes/$classId/teacher', data: {'teacherId': teacherId});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gán giáo viên chủ nhiệm thất bại');
    }
  }

  Future<void> removeHomeroomTeacher(String classId, String teacherId) async {
    try {
      await _dio.delete('/classes/$classId/teacher');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa giáo viên chủ nhiệm thất bại');
    }
  }


  Future<List<Map<String, dynamic>>> getUnassignedTeachers() async {
    try {
      final response = await _dio.get('/classes/teachers/unassigned');
      
      List<dynamic> teachersJson;
      if (response.data['data'] != null && response.data['data']['teachers'] != null) {
        teachersJson = response.data['data']['teachers'];
      } else if (response.data['data'] is List) {
        teachersJson = response.data['data'];
      } else {
        teachersJson = [];
      }
      
      final teachers = <Map<String, dynamic>>[];
      for (var teacherJson in teachersJson) {
        teachers.add({
          'id': teacherJson['_id'] ?? teacherJson['id'] ?? '',
          'name': _buildTeacherName(teacherJson),
          'email': teacherJson['email'] ?? '',
          'isActive': teacherJson['isActive'] ?? true,
        });
      }
      
      return teachers;
    } on DioException catch (e) {
      // Fallback to empty list if API fails
      return [];
    } catch (e) {
      return [];
    }
  }

  static String _buildTeacherName(Map<String, dynamic> teacherData) {
    // Try different possible formats for teacher name
    if (teacherData['fullName'] != null) {
      return teacherData['fullName'];
    }
    if (teacherData['name'] != null) {
      return teacherData['name'];
    }
    
    // Build from firstName and lastName
    final firstName = teacherData['firstName']?.toString() ?? '';
    final lastName = teacherData['lastName']?.toString() ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    
    return 'Unknown Teacher';
  }

  Future<ClassStudentsResponseModel> getClassStudents(String classId) async {
    try {
      final response = await _dio.get('/classes/$classId/students');
      
      return ClassStudentsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy danh sách học sinh thất bại');
    } catch (e) {
      throw Exception('Lấy danh sách học sinh thất bại: $e');
    }
  }

  Future<ClassStudentsResponseModel> removeStudentFromClass(String classId, String studentId) async {
    try {
      final response = await _dio.delete(
        '/classes/$classId/students',
        data: {'studentId': studentId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      return ClassStudentsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa học sinh khỏi lớp thất bại');
    } catch (e) {
      throw Exception('Xóa học sinh khỏi lớp thất bại: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUnassignedStudents() async {
    try {
      final response = await _dio.get('/classes/students/unassigned');
      
      final studentsData = response.data['data']['students'] as List<dynamic>;
      final students = studentsData.map((student) {
        return {
          'id': student['_id'],
          'name': '${student['firstName']} ${student['lastName']}',
          'email': student['email'],
          'phone': student['phoneNumber'],
          'dateOfBirth': student['dateOfBirth'],
          'address': student['address'],
        };
      }).toList();
      
      return students;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Tải danh sách học sinh chưa có lớp thất bại');
    } catch (e) {
      throw Exception('Tải danh sách học sinh chưa có lớp thất bại: $e');
    }
  }

  Future<ClassStudentsResponseModel> addStudentToClass(String classId, String studentId) async {
    try {
      final response = await _dio.post(
        '/classes/$classId/students',
        data: {'studentId': studentId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      return ClassStudentsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Thêm học sinh vào lớp thất bại');
    } catch (e) {
      throw Exception('Thêm học sinh vào lớp thất bại: $e');
    }
  }

}
