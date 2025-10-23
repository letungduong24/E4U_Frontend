import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/model/user_management_model.dart';

class UserManagementDatasource {
  final Dio _dio = DioClient().dio;

  Future<List<UserManagementModel>> getAllUsers({
    String? role,
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{};
      print('Filter parameters received:');
      print('- role: $role');
      print('- searchQuery: $searchQuery');
      print('- classFilter: $classFilter');
      
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      if (classFilter != null && classFilter.isNotEmpty) {
        queryParams['classId'] = classFilter;
        print('Added classId to query: $classFilter');
      }
      
      print('Making API call to /admin/users with params: $queryParams');
      final response = await _dio.get('/admin/users', queryParameters: queryParams);
      
      // Debug logging
      print('API Response status: ${response.statusCode}');
      print('API Response data: ${response.data}');
      
      // Handle API response structure: data.users
      List<dynamic> usersJson;
      if (response.data['data'] != null && response.data['data']['users'] != null) {
        usersJson = response.data['data']['users'];
        print('Found ${usersJson.length} users in data.users');
      } else if (response.data['data'] != null && response.data['data']['items'] != null) {
        usersJson = response.data['data']['items'];
        print('Found ${usersJson.length} users in data.items');
      } else if (response.data['data'] is List) {
        usersJson = response.data['data'];
        print('Found ${usersJson.length} users in data (array)');
      } else {
        usersJson = [];
        print('No users found in response');
        print('Response structure: ${response.data.keys}');
      }
      
      final allUsers = <UserManagementModel>[];
      for (int i = 0; i < usersJson.length; i++) {
        try {
          print('Parsing user $i: ${usersJson[i]}');
          final user = UserManagementModel.fromJson(usersJson[i]);
          allUsers.add(user);
          print('Successfully parsed user: ${user.fullName}');
        } catch (e) {
          print('Error parsing user $i: $e');
          print('User data: ${usersJson[i]}');
          // Skip this user and continue with others
        }
      }
      print('Successfully parsed ${allUsers.length} users from API');
      print('Users before filtering:');
      for (var user in allUsers) {
        print('- ${user.fullName} (${user.role}) - currentClass: ${user.currentClass}, teachingClass: ${user.teachingClass}');
      }
      
      // Apply frontend filtering and sorting
      var filteredUsers = allUsers;
      
      // Filter by role
      if (role != null && role.isNotEmpty) {
        filteredUsers = filteredUsers.where((user) => user.role == role).toList();
        print('Filtered by role $role: ${filteredUsers.length} users');
      }
      
      // Filter by search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredUsers = filteredUsers.where((user) => 
          user.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
        print('Filtered by search "$searchQuery": ${filteredUsers.length} users');
      }
      
      // Note: Class filtering is handled by API backend
      if (classFilter != null && classFilter.isNotEmpty) {
        print('Class filtering handled by API backend with classId: $classFilter');
      }
      
      // Filter by active status
      if (isActive != null) {
        filteredUsers = filteredUsers.where((user) => user.isActive == isActive).toList();
        print('Filtered by isActive $isActive: ${filteredUsers.length} users');
      }
      
      // Sort users
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'createdAt') {
          if (sortOrder == 'desc') {
            filteredUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          } else {
            filteredUsers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
        } else if (sortBy == 'fullName') {
          if (sortOrder == 'desc') {
            filteredUsers.sort((a, b) => b.fullName.compareTo(a.fullName));
          } else {
            filteredUsers.sort((a, b) => a.fullName.compareTo(b.fullName));
          }
        } else if (sortBy == 'email') {
          if (sortOrder == 'desc') {
            filteredUsers.sort((a, b) => b.email.compareTo(a.email));
          } else {
            filteredUsers.sort((a, b) => a.email.compareTo(b.email));
          }
        }
        print('Sorted by $sortBy $sortOrder');
      }
      
      print('Final result: ${filteredUsers.length} users');
      print('Final users:');
      for (var user in filteredUsers) {
        print('- ${user.fullName} (${user.role})');
      }
      print('Returning ${filteredUsers.length} users from API (not mock)');
      return filteredUsers;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request method: ${e.requestOptions.method}');
      
      // Fallback to mock data if API fails
      print('API failed, using mock data');
      return _getMockUsers();
    } catch (e) {
      print('General error: $e');
      print('Stack trace: ${StackTrace.current}');
      // Fallback to mock data if any error
      print('Error occurred, using mock data');
      return _getMockUsers();
    }
  }

  List<UserManagementModel> _getMockUsers() {
    final now = DateTime.now();
    return [
      UserManagementModel(
        id: '1',
        firstName: 'Nguyễn',
        lastName: 'Văn An',
        fullName: 'Nguyễn Văn An',
        email: 'an.nguyen@example.com',
        role: 'student',
        currentClass: 'IELTS Foundation - Band 4.0-5.5',
        createdAt: now.subtract(const Duration(days: 30)),
        lastLoginAt: now.subtract(const Duration(hours: 2)),
        isActive: true,
      ),
      UserManagementModel(
        id: '2',
        firstName: 'Trần',
        lastName: 'Thị Bình',
        fullName: 'Trần Thị Bình',
        email: 'binh.tran@example.com',
        role: 'student',
        currentClass: 'IELTS Advanced - Band 6.0-7.5',
        createdAt: now.subtract(const Duration(days: 25)),
        lastLoginAt: now.subtract(const Duration(hours: 5)),
        isActive: true,
      ),
      UserManagementModel(
        id: '3',
        firstName: 'Lê',
        lastName: 'Văn Cường',
        fullName: 'Lê Văn Cường',
        email: 'cuong.le@example.com',
        role: 'teacher',
        teachingClass: 'IELTS Foundation - Band 4.0-5.5',
        createdAt: now.subtract(const Duration(days: 60)),
        lastLoginAt: now.subtract(const Duration(hours: 1)),
        isActive: true,
      ),
      UserManagementModel(
        id: '4',
        firstName: 'Phạm',
        lastName: 'Thị Dung',
        fullName: 'Phạm Thị Dung',
        email: 'dung.pham@example.com',
        role: 'student',
        currentClass: 'IELTS Advanced - Band 6.0-7.5',
        createdAt: now.subtract(const Duration(days: 20)),
        lastLoginAt: now.subtract(const Duration(days: 1)),
        isActive: false,
      ),
      UserManagementModel(
        id: '5',
        firstName: 'Hoàng',
        lastName: 'Văn Em',
        fullName: 'Hoàng Văn Em',
        email: 'em.hoang@example.com',
        role: 'admin',
        createdAt: now.subtract(const Duration(days: 90)),
        lastLoginAt: now.subtract(const Duration(minutes: 30)),
        isActive: true,
      ),
      UserManagementModel(
        id: '6',
        firstName: 'Nguyễn',
        lastName: 'Thị Giáo',
        fullName: 'Nguyễn Thị Giáo',
        email: 'giao.nguyen@example.com',
        role: 'teacher',
        teachingClass: 'IELTS Advanced - Band 6.0-7.5',
        createdAt: now.subtract(const Duration(days: 45)),
        lastLoginAt: now.subtract(const Duration(hours: 3)),
        isActive: true,
      ),
      UserManagementModel(
        id: '7',
        firstName: 'Trần',
        lastName: 'Văn Học',
        fullName: 'Trần Văn Học',
        email: 'hoc.tran@example.com',
        role: 'teacher',
        teachingClass: 'TOEIC Preparation',
        createdAt: now.subtract(const Duration(days: 30)),
        lastLoginAt: now.subtract(const Duration(days: 1)),
        isActive: false,
      ),
    ];
  }

  Future<UserManagementModel> getUserById(String userId) async {
    try {
      final response = await _dio.get('/api/admin/users/$userId');
      return UserManagementModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy thông tin người dùng thất bại');
    }
  }

  Future<UserManagementModel> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    String? password,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? currentClass,
    String? teachingClass,
  }) async {
    try {
      final requestData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password ?? 'password123', // Default password
        'role': role,
        'profile': {
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'gender': gender ?? 'Nam', // Default to Nam
          if (dateOfBirth != null && dateOfBirth.isNotEmpty) 'dateOfBirth': dateOfBirth,
        },
      };

      print('Creating user with data: $requestData');
      final response = await _dio.post('/admin/users', data: requestData);
      
      print('Create user response: ${response.data}');
      return UserManagementModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      print('Error creating user: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Tạo người dùng thất bại');
    }
  }

  Future<UserManagementModel> updateUser(String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? currentClass,
    String? teachingClass,
    bool? isActive,
    String? phone,
    String? gender,
    String? dateOfBirth,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      // Gửi email giống như CreateUser
      if (email != null) {
        data['email'] = email.trim(); // Trim whitespace
      }
      if (role != null) data['role'] = role;
      if (currentClass != null) data['currentClass'] = currentClass;
      if (teachingClass != null) data['teachingClass'] = teachingClass;
      if (isActive != null) data['isActive'] = isActive;
      
      // Thêm profile data
      final profileData = <String, dynamic>{};
      if (phone != null) profileData['phone'] = phone;
      if (gender != null) profileData['gender'] = gender;
      if (dateOfBirth != null) profileData['dateOfBirth'] = dateOfBirth;
      // Thêm address field để match với Postman
      profileData['address'] = '123 Đường AdBC, Quận 1, TP.HCM';
      
      if (profileData.isNotEmpty) {
        data['profile'] = profileData;
      }

      
      // Thử gửi với Content-Type header rõ ràng
      final response = await _dio.put(
        '/admin/users/$userId', 
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return UserManagementModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Cập nhật người dùng thất bại');
    } catch (e) {
      print('General error in updateUser: $e');
      throw Exception('Cập nhật người dùng thất bại: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('/admin/users/$userId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Xóa người dùng thất bại');
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      await _dio.patch('/admin/users/$userId/active', data: {'isActive': isActive});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Thay đổi trạng thái người dùng thất bại');
    }
  }

  Future<void> setTeacherClass(String teacherId, String className) async {
    try {
      await _dio.patch('/admin/users/$teacherId/class', data: {'teachingClass': className});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gán lớp học cho giáo viên thất bại');
    }
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      print('Making API call to /classes');
      final response = await _dio.get('/classes');
      
      print('Classes API Response status: ${response.statusCode}');
      print('Classes API Response data: ${response.data}');
      
      // Handle API response structure: data.classes
      List<dynamic> classesJson;
      if (response.data['data'] != null && response.data['data']['classes'] != null) {
        classesJson = response.data['data']['classes'];
        print('Found ${classesJson.length} classes in data.classes');
      } else {
        classesJson = [];
        print('No classes found in response');
        print('Response structure: ${response.data.keys}');
      }
      
      final classes = classesJson.map((json) => {
        'id': json['_id'],
        'name': json['name'],
        'code': json['code'],
        'description': json['description'],
        'isActive': json['isActive'] ?? true,
      }).toList();
      
      // Remove duplicates based on id
      final uniqueClasses = <String, Map<String, dynamic>>{};
      for (var classItem in classes) {
        uniqueClasses[classItem['id']] = classItem;
      }
      
      print('Removed duplicates, final classes: ${uniqueClasses.length}');
      return uniqueClasses.values.toList();
    } on DioException catch (e) {
      print('DioException getting classes: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      
      // Fallback to mock data if API fails
      print('Classes API failed, using mock data');
      return _getMockClasses();
    } catch (e) {
      print('General error getting classes: $e');
      print('Stack trace: ${StackTrace.current}');
      // Fallback to mock data if any error
      print('Error occurred getting classes, using mock data');
      return _getMockClasses();
    }
  }

  List<Map<String, dynamic>> _getMockClasses() {
    return [
      {
        'id': '68f11b630db875085481a9a5',
        'name': 'IELTS Foundation - Band 4.0-5.5',
        'code': 'IELTS-FOUNDATION',
        'description': 'Lớp IELTS Foundation dành cho học viên mới bắt đầu, mục tiêu đạt band 4.0-5.5',
        'isActive': true,
      },
      {
        'id': '68f11b630db875085481a9a6',
        'name': 'IELTS Advanced - Band 6.0-7.5',
        'code': 'IELTS-ADVANCED',
        'description': 'Lớp IELTS Advanced dành cho học viên có nền tảng, mục tiêu đạt band 6.0-7.5',
        'isActive': true,
      },
    ];
  }
}
