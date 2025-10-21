import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/datasource/user_management_datasource.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/repository/user_management_repository_impl.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/usecase/get_all_users_usecase.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/usecase/create_user_usecase.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/usecase/update_user_usecase.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/usecase/delete_user_usecase.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/usecase/toggle_user_status_usecase.dart';

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

  // Dependencies
  late final GetAllUsersUsecase _getAllUsersUsecase;
  late final CreateUserUsecase _createUserUsecase;
  late final UpdateUserUsecase _updateUserUsecase;
  late final DeleteUserUsecase _deleteUserUsecase;
  late final ToggleUserStatusUsecase _toggleUserStatusUsecase;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadUsers();
  }

  void _initializeDependencies() {
    final datasource = UserManagementDatasource();
    final repository = UserManagementRepositoryImpl(datasource);
    
    _getAllUsersUsecase = GetAllUsersUsecase(repository);
    _createUserUsecase = CreateUserUsecase(repository);
    _updateUserUsecase = UpdateUserUsecase(repository);
    _deleteUserUsecase = DeleteUserUsecase(repository);
    _toggleUserStatusUsecase = ToggleUserStatusUsecase(repository);
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
      
      final result = await _getAllUsersUsecase(
        role: selectedRole.value.isEmpty ? null : selectedRole.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        classFilter: selectedClass.value.isEmpty ? null : selectedClass.value,
        isActive: null, // Don't filter by isActive - show all users
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );
      
      print('Received ${result.length} users from API');
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
    String? currentClass,
    String? teachingClass,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _createUserUsecase(
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
        currentClass: currentClass,
        teachingClass: teachingClass,
      );
      
      await loadUsers(); // Reload users after creation
    } catch (e) {
      error.value = e.toString();
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
      
      await _updateUserUsecase(
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
      
      await _deleteUserUsecase(userId);
      
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
      
      await _toggleUserStatusUsecase(userId, isActive);
      
      await loadUsers(); // Reload users after status change
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    loadUsers();
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
    loadUsers();
  }

  void setSelectedClass(String className) {
    selectedClass.value = className;
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
}
