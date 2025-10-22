import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';

abstract class UserManagementRepository {
  Future<List<UserManagementEntity>> getAllUsers({
    String? role,
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  });

  Future<UserManagementEntity> getUserById(String userId);

  Future<UserManagementEntity> createUser({
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
  });

  Future<UserManagementEntity> updateUser(String userId, {
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
  });

  Future<void> deleteUser(String userId);

  Future<void> toggleUserStatus(String userId, bool isActive);

  Future<void> setTeacherClass(String teacherId, String className);

  Future<List<Map<String, dynamic>>> getClasses();
}
