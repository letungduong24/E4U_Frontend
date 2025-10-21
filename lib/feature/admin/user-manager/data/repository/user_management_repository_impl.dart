import 'package:e4uflutter/feature/admin/user-manager/data/datasource/user_management_datasource.dart';
import 'package:e4uflutter/feature/admin/user-manager/data/model/user_management_model.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementDatasource _datasource;

  UserManagementRepositoryImpl(this._datasource);

  @override
  Future<List<UserManagementEntity>> getAllUsers({
    String? role,
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    final users = await _datasource.getAllUsers(
      role: role,
      searchQuery: searchQuery,
      classFilter: classFilter,
      isActive: isActive,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    return users;
  }

  @override
  Future<UserManagementEntity> getUserById(String userId) async {
    return await _datasource.getUserById(userId);
  }

  @override
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
  }) async {
    return await _datasource.createUser(
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
  }

  @override
  Future<UserManagementEntity> updateUser(String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? currentClass,
    String? teachingClass,
    bool? isActive,
  }) async {
    return await _datasource.updateUser(
      userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      role: role,
      currentClass: currentClass,
      teachingClass: teachingClass,
      isActive: isActive,
    );
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _datasource.deleteUser(userId);
  }

  @override
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    await _datasource.toggleUserStatus(userId, isActive);
  }

  @override
  Future<void> setTeacherClass(String teacherId, String className) async {
    await _datasource.setTeacherClass(teacherId, className);
  }

  @override
  Future<List<Map<String, dynamic>>> getClasses() async {
    return await _datasource.getClasses();
  }
}
