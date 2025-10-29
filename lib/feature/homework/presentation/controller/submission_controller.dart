import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/data/datasource/submission_datasource.dart';
import 'package:e4uflutter/feature/homework/data/repository/submission_repository_impl.dart';
import 'package:e4uflutter/feature/homework/domain/entity/submission_entity.dart';

class SubmissionController extends GetxController {
  // Observable state
  final RxList<SubmissionEntity> submissions = <SubmissionEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedStatus = ''.obs;

  // Dependencies
  late final SubmissionRepositoryImpl _repository;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    // Don't auto-load - let the screen decide which data to load
  }

  void _initializeDependencies() {
    final datasource = SubmissionDatasource();
    _repository = SubmissionRepositoryImpl(datasource);
  }

  Future<void> loadSubmissions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _repository.getStudentSubmissions(
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
      );

      submissions.value = result;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGradedSubmissions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _repository.getGradedSubmissions();

      submissions.value = result;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSubmissions() async {
    await loadGradedSubmissions();
  }

  Future<void> filterByStatus(String status) async {
    selectedStatus.value = status;
    await loadSubmissions();
  }

  void clearStatusFilter() {
    selectedStatus.value = '';
  }

  String getStatusDisplayName(String status) {
    switch (status) {
      case 'submitted':
        return 'Đã nộp';
      case 'graded':
        return 'Đã chấm';
      default:
        return status;
    }
  }

  String? getGradeColor(int? grade) {
    if (grade == null) return null;
    if (grade >= 80) return '#10B981'; // green
    if (grade >= 60) return '#F59E0B'; // yellow
    return '#EF4444'; // red
  }
}

