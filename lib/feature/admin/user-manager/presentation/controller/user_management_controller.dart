import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/datasource/user_management_datasource.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/repository/user_management_repository_impl.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';

class UserManagementController extends GetxController {
  // Observable state
  final RxList<UserManagementEntity> users = <UserManagementEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedRole = ''.obs;
  final RxString selectedClass = ''.obs;
  final RxBool showActiveOnly = true.obs;
  final RxString sortBy = 'createdAt'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;

  // Dependencies
  late final UserManagementRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadUsers();
    // Load classes immediately
    loadClasses();
  }


  void _initializeDependencies() {
    final datasource = UserManagementDatasource();
    _repository = UserManagementRepositoryImpl(datasource);
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      print('Loading users with filters:');
      print('- role: ${selectedRole.value}');
      print('- searchQuery: ${searchQuery.value}');
      print('- classFilter: ${selectedClass.value}');
      print('- sortBy: ${sortBy.value}');
      print('- sortOrder: ${sortOrder.value}');
      
      final result = await _repository.getAllUsers(
        role: selectedRole.value.isEmpty ? null : selectedRole.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        classFilter: selectedClass.value.isEmpty ? null : selectedClass.value,
        isActive: null, // Don't filter by isActive - show all users
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );
      
      print('Received ${result.length} users from API');
      print('Users details:');
      for (var user in result) {
        print('- ${user.fullName} (${user.email}) - ${user.role}');
      }
      users.value = result;
    } catch (e) {
      print('Error loading users: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser({
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
      isLoading.value = true;
      error.value = '';
      
      await _repository.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        password: password,
        phone: phone,
        gender: gender,
        dateOfBirth: dateOfBirth,
        currentClass: currentClass,
        teachingClass: teachingClass,
      );
      
      await loadUsers(); // Reload users after creation
    } catch (e) {
      error.value = e.toString();
      rethrow; // Re-throw the exception so dialog can catch it
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? currentClass,
    String? teachingClass,
    bool? isActive,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.updateUser(
        userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        currentClass: currentClass,
        teachingClass: teachingClass,
        isActive: isActive,
      );
      
      await loadUsers(); // Reload users after update
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.deleteUser(userId);
      
      await loadUsers(); // Reload users after deletion
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.toggleUserStatus(userId, isActive);
      
      await loadUsers(); // Reload users after status change
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setTeacherClass(String teacherId, String className) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.setTeacherClass(teacherId, className);
      
      await loadUsers(); // Reload users after setting class
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    // Don't search automatically - only when user presses Enter
  }

  void performSearch() {
    loadUsers();
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
    loadUsers();
  }

  void setSelectedClass(String classId) {
    selectedClass.value = classId;
    print('Selected class ID: $classId');
    loadUsers();
  }

  void setShowActiveOnly(bool showActive) {
    showActiveOnly.value = showActive;
    loadUsers();
  }

  void setSorting(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    loadUsers();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedRole.value = '';
    selectedClass.value = '';
    showActiveOnly.value = true;
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
    loadUsers();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedRole.value = '';
    selectedClass.value = '';
    showActiveOnly.value = true;
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
  }

  Future<void> loadClasses() async {
    try {
      print('Loading classes...');
      final classesList = await _repository.getClasses();
      print('Loaded ${classesList.length} classes:');
      for (var classItem in classesList) {
        print('- ${classItem['name']} (${classItem['id']})');
      }
      classes.value = classesList;
      print('Classes updated in controller: ${classes.length}');
    } catch (e) {
      print('Error loading classes: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }
}
