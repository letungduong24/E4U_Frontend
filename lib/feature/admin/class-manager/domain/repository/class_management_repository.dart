import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';

abstract class ClassManagementRepository {
  Future<List<ClassManagementEntity>> getAllClasses({
    String? teacher,
    String? searchQuery,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  });

  Future<ClassManagementEntity> getClassById(String classId);

  Future<ClassManagementEntity> createClass({
    required String name,
    required String code,
    required String homeroomTeacherId,
    String? description,
    int? maxStudents,
  });

  Future<ClassManagementEntity> updateClass(String classId, {
    String? name,
    String? code,
    String? homeroomTeacherId,
    String? description,
    int? maxStudents,
    bool? isActive,
  });

  Future<void> deleteClass(String classId);

  Future<void> toggleClassStatus(String classId, bool isActive);

  Future<void> setHomeroomTeacher(String classId, String teacherId);

  Future<void> removeHomeroomTeacher(String classId, String teacherId);

  Future<List<Map<String, dynamic>>> getUnassignedTeachers();

  Future<ClassStudentsResponseEntity> getClassStudents(String classId);

  Future<ClassStudentsResponseEntity> removeStudentFromClass(String classId, String studentId);

  Future<List<Map<String, dynamic>>> getUnassignedStudents();

  Future<ClassStudentsResponseEntity> addStudentToClass(String classId, String studentId);
}
