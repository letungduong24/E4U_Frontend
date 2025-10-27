import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/datasource/class_management_datasource.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/repository/class_management_repository_impl.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';

class ClassStudentsController extends GetxController {
  // Observable state
  final RxList<ClassStudentEntity> students = <ClassStudentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString className = ''.obs;
  final RxString classCode = ''.obs;
  final RxString classId = ''.obs;
  final RxInt maxStudents = 0.obs;
  final RxBool isActive = true.obs;
  final RxList<Map<String, dynamic>> unassignedStudents = <Map<String, dynamic>>[].obs;

  // Dependencies
  late final ClassManagementRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    
    // Get arguments from navigation
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      classId.value = arguments['classId'] ?? '';
      className.value = arguments['className'] ?? '';
      classCode.value = arguments['classCode'] ?? '';
    }
    
    loadClassStudents();
  }

  void _initializeDependencies() {
    final datasource = ClassManagementDatasource();
    _repository = ClassManagementRepositoryImpl(datasource);
  }

  Future<void> loadClassStudents() async {
    if (classId.value.isEmpty) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await _repository.getClassStudents(classId.value);
      
      students.value = response.students;
      maxStudents.value = response.maxStudents;
      isActive.value = response.isActive;
      
      // Update class info if not set from arguments
      if (className.value.isEmpty) {
        className.value = response.className;
      }
      if (classCode.value.isEmpty) {
        classCode.value = response.classCode;
      }
    } catch (e) {
      print('Error loading class students: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void performSearch() {
    // For now, just reload the data
    // In the future, this could be implemented with server-side search
    loadClassStudents();
  }

  List<ClassStudentEntity> get filteredStudents {
    if (searchQuery.value.isEmpty) {
      return students;
    }
    
    return students.where((student) {
      final query = searchQuery.value.toLowerCase();
      return student.fullName.toLowerCase().contains(query) ||
             student.email.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> refreshStudents() async {
    await loadClassStudents();
  }

  Future<void> loadUnassignedStudents() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final students = await _repository.getUnassignedStudents();
      unassignedStudents.value = students;
    } catch (e) {
      print('Error loading unassigned students: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeStudentFromClass(String studentId) async {
    if (classId.value.isEmpty) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.removeStudentFromClass(classId.value, studentId);
      
      // Reload students after successful removal
      await loadClassStudents();
    } catch (e) {
      print('Error removing student from class: $e');
      error.value = e.toString();
      rethrow; // Re-throw để dialog có thể catch
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStudentToClass(String studentId) async {
    if (classId.value.isEmpty) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.addStudentToClass(classId.value, studentId);
      
      // Reload students after successful addition
      await loadClassStudents();
    } catch (e) {
      print('Error adding student to class: $e');
      error.value = e.toString();
      rethrow; // Re-throw để dialog có thể catch
    } finally {
      isLoading.value = false;
    }
  }
}
