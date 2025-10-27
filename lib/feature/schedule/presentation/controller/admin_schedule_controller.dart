import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';

class AdminScheduleController extends GetxController {
  final RxList<ScheduleEntity> schedules = <ScheduleEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  late final ScheduleRepositoryImpl _repository;
  late final TokenStorage _tokenStorage;
  DateTime? _currentDate;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final datasource = ScheduleDataSource();
    _repository = ScheduleRepositoryImpl(datasource);
    _tokenStorage = TokenStorage();
  }

  Future<void> loadSchedules([DateTime? date]) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final targetDate = date ?? DateTime.now();
      _currentDate = targetDate;
      final day = _formatDate(targetDate);
      final token = await _tokenStorage.readToken();
      
      // Get schedules by date for admin
      final fetchedSchedules = await _repository.getSchedulesByDate(day, token);
      
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
      
      final token = await _tokenStorage.readToken();
      await _repository.createSchedule(scheduleData, token);
      
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
    final token = await _tokenStorage.readToken();
    await _repository.updateSchedule(scheduleId, updates, token);
    
    // Reload schedules after updating - reload current date
    await loadSchedules(_currentDate);
  }

  Future<void> deleteSchedule(String scheduleId) async {
    final token = await _tokenStorage.readToken();
    await _repository.deleteSchedule(scheduleId, token);
    
    // Remove from local list
    schedules.removeWhere((schedule) => schedule.id == scheduleId);
  }

}
