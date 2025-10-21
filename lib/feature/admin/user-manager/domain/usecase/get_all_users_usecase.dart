import 'package:e4uflutter/feature/admin/user-manager/domain/entity/user_management_entity.dart';
import 'package:e4uflutter/feature/admin/user-manager/domain/repository/user_management_repository.dart';

class GetAllUsersUsecase {
  final UserManagementRepository _repository;

  GetAllUsersUsecase(this._repository);

  Future<List<UserManagementEntity>> call({
    String? role,
    String? searchQuery,
    String? classFilter,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await _repository.getAllUsers(
      role: role,
      searchQuery: searchQuery,
      classFilter: classFilter,
      isActive: isActive,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
