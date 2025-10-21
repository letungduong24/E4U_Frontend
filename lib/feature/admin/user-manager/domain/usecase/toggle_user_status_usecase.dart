import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class ToggleUserStatusUsecase {
  final UserManagementRepository _repository;

  ToggleUserStatusUsecase(this._repository);

  Future<void> call(String userId, bool isActive) async {
    await _repository.toggleUserStatus(userId, isActive);
  }
}
