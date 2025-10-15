import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';

abstract class AuthRepository{
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> getCurrentUser();
  Future<void> logout();
}