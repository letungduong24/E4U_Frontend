import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';

class AdminScheduleController extends GetxController {
  final RxList<ScheduleEntity> schedules = <ScheduleEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  late final ScheduleRepositoryImpl _repository;
  DateTime? _currentDate;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final datasource = ScheduleDataSource();
    _repository = ScheduleRepositoryImpl(datasource);
  }

  Future<void> loadSchedules([DateTime? date]) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final targetDate = date ?? DateTime.now();
      _currentDate = targetDate;
      final day = _formatDate(targetDate);
      
      // Get schedules by date for admin
      final fetchedSchedules = await _repository.getSchedulesByDate(day);
      
      schedules.value = fetchedSchedules;
      isLoading.value = false;
    } catch (e) {
      // Keep existing schedules if API fails
      isLoading.value = false;
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> createSchedule(Map<String, dynamic> scheduleData) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.createSchedule(scheduleData);
      
      // Reload schedules after creating - reload current date
      await loadSchedules(_currentDate);
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSchedule(String scheduleId, Map<String, dynamic> updates) async {
    await _repository.updateSchedule(scheduleId, updates);
    
    // Reload schedules after updating - reload current date
    await loadSchedules(_currentDate);
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await _repository.deleteSchedule(scheduleId);
    
    // Remove from local list
    schedules.removeWhere((schedule) => schedule.id == scheduleId);
  }

}
