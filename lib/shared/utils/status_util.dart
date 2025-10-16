import 'dart:ui';

import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';

class StatusUtil {
  static String GetStatusDisplayName(String status) {
    switch (status) {
      case 'completed':
        return 'Đã hoàn thành';
      case 'enrolled':
        return 'Đang học';

      default:
        return 'Đang học';
    }
  }

  static Color GetStatusDisplayColor(String status) {
    switch (status) {
      case 'completed':
        return Color(0xFF40B362);
      case 'enrolled':
        return Color(0xFFB7B34B);
      default:
        return Color(0xFFB7B34B);
    }
  }
}