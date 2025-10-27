import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';

class TeacherScheduleController extends GetxController {
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
    _currentDate = DateTime.now();
    loadSchedules();
  }

  void _initializeDependencies() {
    final datasource = ScheduleDataSource();
    _repository = ScheduleRepositoryImpl(datasource);
    _tokenStorage = TokenStorage();
  }

  Future<void> loadSchedules([DateTime? date]) async {
    if (date != null) {
      _currentDate = date;
    }
    
    isLoading.value = true;
    error.value = '';
    
    try {
      final day = _formatDate(_currentDate ?? DateTime.now());
      final token = await _tokenStorage.readToken();
      final result = await _repository.getMySchedule(day, token);
      schedules.value = result;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
