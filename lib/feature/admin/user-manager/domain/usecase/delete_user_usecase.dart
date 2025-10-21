import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class DeleteUserUsecase {
  final UserManagementRepository _repository;

  DeleteUserUsecase(this._repository);

  Future<void> call(String userId) async {
    await _repository.deleteUser(userId);
  }
}
