import 'package:e4uflutter/feature/auth/data/datasource/auth_datasource.dart';
import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';
import 'package:e4uflutter/feature/auth/domain/repository/auth_repo.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _dts;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._dts, this._tokenStorage);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await _dts.login(email, password);
    return user;
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = await _dts.getCurrentUser();
    return user;
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}
