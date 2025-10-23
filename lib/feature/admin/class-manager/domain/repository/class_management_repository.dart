import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';

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
}
