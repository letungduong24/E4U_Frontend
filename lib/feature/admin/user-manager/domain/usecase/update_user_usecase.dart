import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class UpdateUserUsecase {
  final UserManagementRepository _repository;

  UpdateUserUsecase(this._repository);

  Future<UserManagementEntity> call(String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? currentClass,
    String? teachingClass,
    bool? isActive,
  }) async {
    return await _repository.updateUser(
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
}
