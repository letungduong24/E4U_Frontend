import 'package:e4uflutter/feature/auth/domain/repository/auth_repo.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future<void> call() async {
    await _authRepository.logout();
  }
}
