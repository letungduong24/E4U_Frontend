import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';

abstract class AuthRepository{
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> getCurrentUser();
  Future<UserEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? avatar,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? address,
    bool? notification,
  });
  Future<void> logout();
}