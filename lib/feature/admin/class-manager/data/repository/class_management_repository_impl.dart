import 'package:e4uflutter/feature/admin/class-manager/data/datasource/class_management_datasource.dart';
import 'package:e4uflutter/feature/admin/class-manager/data/model/class_management_model.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/repository/class_management_repository.dart';

class ClassManagementRepositoryImpl implements ClassManagementRepository {
  final ClassManagementDatasource _datasource;

  ClassManagementRepositoryImpl(this._datasource);

  @override
  Future<List<ClassManagementEntity>> getAllClasses({
    String? teacher,
    String? searchQuery,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    final classes = await _datasource.getAllClasses(
      teacher: teacher,
      searchQuery: searchQuery,
      isActive: isActive,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    return classes;
  }

  @override
  Future<ClassManagementEntity> getClassById(String classId) async {
    return await _datasource.getClassById(classId);
  }

  @override
  Future<ClassManagementEntity> createClass({
    required String name,
    required String code,
    required String homeroomTeacherId,
    String? description,
    int? maxStudents,
  }) async {
    return await _datasource.createClass(
      name: name,
      code: code,
      homeroomTeacherId: homeroomTeacherId,
      description: description,
      maxStudents: maxStudents,
    );
  }

  @override
  Future<ClassManagementEntity> updateClass(String classId, {
    String? name,
    String? code,
    String? homeroomTeacherId,
    String? description,
    int? maxStudents,
    bool? isActive,
  }) async {
    return await _datasource.updateClass(
      classId,
      name: name,
      code: code,
      homeroomTeacherId: homeroomTeacherId,
      description: description,
      maxStudents: maxStudents,
      isActive: isActive,
    );
  }

  @override
  Future<void> deleteClass(String classId) async {
    await _datasource.deleteClass(classId);
  }

  @override
  Future<void> toggleClassStatus(String classId, bool isActive) async {
    await _datasource.toggleClassStatus(classId, isActive);
  }

  @override
  Future<void> setHomeroomTeacher(String classId, String teacherId) async {
    await _datasource.setHomeroomTeacher(classId, teacherId);
  }

  @override
  Future<void> removeHomeroomTeacher(String classId, String teacherId) async {
    await _datasource.removeHomeroomTeacher(classId, teacherId);
  }

  @override
  Future<List<Map<String, dynamic>>> getUnassignedTeachers() async {
    return await _datasource.getUnassignedTeachers();
  }

  @override
  Future<ClassStudentsResponseEntity> getClassStudents(String classId) async {
    return await _datasource.getClassStudents(classId);
  }

  @override
  Future<ClassStudentsResponseEntity> removeStudentFromClass(String classId, String studentId) async {
    return await _datasource.removeStudentFromClass(classId, studentId);
  }

  @override
  Future<List<Map<String, dynamic>>> getUnassignedStudents() async {
    return await _datasource.getUnassignedStudents();
  }

  @override
  Future<ClassStudentsResponseEntity> addStudentToClass(String classId, String studentId) async {
    return await _datasource.addStudentToClass(classId, studentId);
  }
}
