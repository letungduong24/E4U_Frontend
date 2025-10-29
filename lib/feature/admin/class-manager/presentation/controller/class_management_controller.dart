import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/datasource/class_management_datasource.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/repository/class_management_repository_impl.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/presentation/controller/user_management_controller.dart';

class ClassManagementController extends GetxController {
  // Observable state
  final RxList<ClassManagementEntity> classes = <ClassManagementEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTeacher = ''.obs;
  final RxBool showActiveOnly = true.obs;
  final RxString sortBy = 'createdAt'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxList<Map<String, dynamic>> teachers = <Map<String, dynamic>>[].obs;

  // Dependencies
  late final ClassManagementRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadClasses();
    // Load teachers immediately
    loadTeachers();
  }

  void _initializeDependencies() {
    final datasource = ClassManagementDatasource();
    _repository = ClassManagementRepositoryImpl(datasource);
  }

  Future<void> loadClasses() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final result = await _repository.getAllClasses(
        teacher: selectedTeacher.value.isEmpty ? null : selectedTeacher.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        isActive: null, // Don't filter by isActive - show all classes
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );
      
      classes.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createClass({
    required String name,
    required String code,
    required String homeroomTeacherId,
    String? description,
    int? maxStudents,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.createClass(
        name: name,
        code: code,
        homeroomTeacherId: homeroomTeacherId,
        description: description,
        maxStudents: maxStudents,
      );
      
      await loadClasses(); // Reload classes after creation
    } catch (e) {
      error.value = e.toString();
      rethrow; // Re-throw the exception so dialog can catch it
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateClass(String classId, {
    String? name,
    String? code,
    String? homeroomTeacherId,
    String? description,
    int? maxStudents,
    bool? isActive,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.updateClass(
        classId,
        name: name,
        code: code,
        homeroomTeacherId: homeroomTeacherId,
        description: description,
        maxStudents: maxStudents,
        isActive: isActive,
      );
      
      // Reload classes after successful update
      try {
        await loadClasses();
      } catch (loadError) {
        // Log load error but don't fail the update
      }
    } catch (e) {
      error.value = e.toString();
      rethrow; // Re-throw để dialog có thể catch
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.deleteClass(classId);
      
      await loadClasses(); // Reload classes after deletion
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleClassStatus(String classId, bool isActive) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.toggleClassStatus(classId, isActive);
      
      await loadClasses(); // Reload classes after status change
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
    loadClasses();
  }

  void setSelectedTeacher(String teacherId) {
    selectedTeacher.value = teacherId;
    loadClasses();
  }

  void setShowActiveOnly(bool showActive) {
    showActiveOnly.value = showActive;
    loadClasses();
  }

  void setSorting(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    loadClasses();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedTeacher.value = '';
    showActiveOnly.value = true;
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
    loadClasses();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedTeacher.value = '';
    showActiveOnly.value = true;
    sortBy.value = 'createdAt';
    sortOrder.value = 'desc';
  }

  Future<void> loadAllTeachers() async {
    try {
      // Clear existing teachers first to show loading state
      teachers.value = [];
      
      // Use UserManagementController to get teachers
      UserManagementController userController;
      try {
        userController = Get.find<UserManagementController>();
      } catch (e) {
        userController = Get.put(UserManagementController());
      }
      
      // Set role and load users without triggering setState during build
      userController.selectedRole.value = 'teacher';
      await userController.loadUsers();
      
      // Convert UserManagementEntity to Map format
      final teachersList = userController.users.map((user) => {
        'id': user.id,
        'name': user.fullName,
        'email': user.email,
        'isActive': user.isActive,
      }).toList();
      
      teachers.value = teachersList;
    } catch (e) {
      // Fallback to empty list
      teachers.value = [];
    }
  }

  Future<void> loadTeachers() async {
    try {
      // Clear existing teachers first to show loading state
      teachers.value = [];
      final unassignedTeachers = await _repository.getUnassignedTeachers();
      
      teachers.value = unassignedTeachers;
    } catch (e) {
      // Fallback to empty list
      teachers.value = [];
    }
  }

  Future<void> setHomeroomTeacher(String classId, String teacherId) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.setHomeroomTeacher(classId, teacherId);
      await loadClasses(); // Reload classes to update UI
      await loadTeachers(); // Reload teachers to update dropdown
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeHomeroomTeacher(String classId, String teacherId) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.removeHomeroomTeacher(classId, teacherId);
      await loadClasses(); // Reload classes to update UI
      await loadTeachers(); // Reload teachers to update dropdown
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
