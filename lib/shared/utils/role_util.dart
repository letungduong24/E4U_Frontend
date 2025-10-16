import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';

class RoleUtil{
  static String GetRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Quản trị viên';
      case 'teacher':
        return 'Giáo viên';
      case 'student':
        return 'Học viên';
      default:
        return 'Người dùng';
    }
  }

  static String GetRoleTitle(UserEntity user) {
    String role = user.role;
    String? className = user.currentClass;
    String? teachingClass = user.teachingClass;

    switch (role) {
      case 'admin':
        return 'Quản trị viên';
      case 'teacher':
        return 'Giáo viên lớp: $teachingClass';
      case 'student':
        return 'Học viên lớp: $className';
      default:
        return 'Người dùng';
    }
  }
}