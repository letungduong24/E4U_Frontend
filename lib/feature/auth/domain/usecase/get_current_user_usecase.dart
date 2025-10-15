import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';
import 'package:e4uflutter/feature/auth/domain/repository/auth_repo.dart';

class GetCurrentUserUsecase {
  final AuthRepository _authRepository;

  GetCurrentUserUsecase(this._authRepository);

  Future<UserEntity> call() async {
    return await _authRepository.getCurrentUser();
  }
}
