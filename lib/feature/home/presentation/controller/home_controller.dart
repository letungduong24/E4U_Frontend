import 'package:get/get.dart';
import 'package:e4uflutter/feature/home/data/datasource/home_datasource.dart';
import 'package:e4uflutter/feature/home/data/repository/home_repository_impl.dart';
import 'package:e4uflutter/feature/home/domain/entity/home_stats_entity.dart';
import 'package:e4uflutter/feature/home/domain/entity/upcoming_schedule_entity.dart';

class HomeController extends GetxController {
  final Rx<HomeStatsEntity?> stats = Rx<HomeStatsEntity?>(null);
  final RxList<UpcomingScheduleEntity> upcomingSchedules = <UpcomingScheduleEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSchedules = false.obs;
  final RxString error = ''.obs;
  final RxString scheduleError = ''.obs;

  late final HomeRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadAdminDashboardStats();
  }

  void _initializeDependencies() {
    final datasource = HomeDatasource();
    _repository = HomeRepositoryImpl(datasource);
  }

  Future<void> loadAdminDashboardStats() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _repository.getAdminDashboardStats();
      stats.value = result;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      error.value = errorMessage;
    }
  }

  Future<void> loadUpcomingSchedules() async {
    try {
      isLoadingSchedules.value = true;
      scheduleError.value = '';
      final result = await _repository.getUpcomingSchedules();
      upcomingSchedules.value = result;
      isLoadingSchedules.value = false;
    } catch (e) {
      isLoadingSchedules.value = false;
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      scheduleError.value = errorMessage;
    }
  }

  void refreshStats() {
    loadAdminDashboardStats();
  }

  void refreshSchedules() {
    loadUpcomingSchedules();
  }
}

