import 'package:e4uflutter/feature/home/data/datasource/home_datasource.dart';
import 'package:e4uflutter/feature/home/domain/entity/home_stats_entity.dart';
import 'package:e4uflutter/feature/home/domain/entity/upcoming_schedule_entity.dart';
import 'package:e4uflutter/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _datasource;

  HomeRepositoryImpl(this._datasource);

  @override
  Future<HomeStatsEntity> getAdminDashboardStats() async {
    return await _datasource.getAdminDashboardStats();
  }

  @override
  Future<List<UpcomingScheduleEntity>> getUpcomingSchedules() async {
    return await _datasource.getUpcomingSchedules();
  }
}

