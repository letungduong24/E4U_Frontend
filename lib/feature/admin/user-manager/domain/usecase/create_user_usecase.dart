import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class CreateUserUsecase {
  final UserManagementRepository _repository;

  CreateUserUsecase(this._repository);

  Future<UserManagementEntity> call({
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    String? currentClass,
    String? teachingClass,
  }) async {
    return await _repository.createUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      role: role,
      currentClass: currentClass,
      teachingClass: teachingClass,
    );
  }
}
