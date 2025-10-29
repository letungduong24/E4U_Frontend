import 'package:e4uflutter/feature/home/domain/entity/home_stats_entity.dart';
import 'package:e4uflutter/feature/home/domain/entity/upcoming_schedule_entity.dart';

abstract class HomeRepository {
  Future<HomeStatsEntity> getAdminDashboardStats();
  Future<List<UpcomingScheduleEntity>> getUpcomingSchedules();
}

