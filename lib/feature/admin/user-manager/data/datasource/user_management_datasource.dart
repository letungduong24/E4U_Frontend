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
      // API chưa hỗ trợ filter/sort, chỉ lấy tất cả users
      print('Making API call to /admin/users (no filters - API not ready)');
      final response = await _dio.get('/admin/users');
      
      // Debug logging
      print('API Response status: ${response.statusCode}');
      print('API Response data: ${response.data}');
      
      // Handle API response structure: data.items
      List<dynamic> usersJson;
      if (response.data['data'] != null && response.data['data']['items'] != null) {
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
      
      final allUsers = usersJson.map((json) => UserManagementModel.fromJson(json)).toList();
      print('Parsed ${allUsers.length} users from API');
      
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
      
      // Filter by class
      if (classFilter != null && classFilter.isNotEmpty) {
        filteredUsers = filteredUsers.where((user) => 
          (user.currentClass != null && user.currentClass!.toLowerCase().contains(classFilter.toLowerCase())) ||
          (user.teachingClass != null && user.teachingClass!.toLowerCase().contains(classFilter.toLowerCase()))
        ).toList();
        print('Filtered by class "$classFilter": ${filteredUsers.length} users');
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
      return filteredUsers;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      
      // Fallback to mock data if API fails
      print('API failed, using mock data');
      return _getMockUsers();
    } catch (e) {
      print('General error: $e');
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
    ];
  }

  Future<UserManagementModel> getUserById(String userId) async {
    try {
      final response = await _dio.get('/admin/users/$userId');
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
    String? currentClass,
    String? teachingClass,
  }) async {
    try {
      final response = await _dio.post('/admin/users', data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
        'currentClass': currentClass,
        'teachingClass': teachingClass,
      });
      return UserManagementModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
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
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (email != null) data['email'] = email;
      if (role != null) data['role'] = role;
      if (currentClass != null) data['currentClass'] = currentClass;
      if (teachingClass != null) data['teachingClass'] = teachingClass;
      if (isActive != null) data['isActive'] = isActive;

      final response = await _dio.put('/admin/users/$userId', data: data);
      return UserManagementModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Cập nhật người dùng thất bại');
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
}
