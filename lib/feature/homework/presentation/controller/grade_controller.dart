import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/data/datasource/submission_datasource.dart';
import 'package:e4uflutter/feature/homework/data/repository/submission_repository_impl.dart';
import 'package:e4uflutter/feature/homework/domain/entity/submission_entity.dart';

class GradeController extends GetxController {
  // Observable state

  //ds bài nộp
  //tải dữ liệu loading
  //tbao lỗi
  // thay đổi trạng thái lọc submiit hoặc graded
  final RxList<SubmissionEntity> submissions = <SubmissionEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedStatus = ''.obs;

  // Dependencies
  //Controller phụ thuộc vào repository, nên nó cần khởi tạo SubmissionRepositoryImpl.
  late final SubmissionRepositoryImpl _repository;
  //hàm khưởi tạo  ban đầu giống initState
  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    // Don't auto-load - let the screen decide which data to load
  }
  // khởi tạo phụ thuộc
  void _initializeDependencies() {
    final datasource = SubmissionDatasource();
    _repository = SubmissionRepositoryImpl(datasource);
  }


  //xem danh sách abfi tập đã chấm điểm
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

  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _repository.gradeSubmission(
        submissionId: submissionId,
        grade: grade,
        feedback: feedback,
      );
      
      // Reload graded submissions to get updated data
      await loadGradedSubmissions();
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  String? getGradeColor(int? grade) {
    if (grade == null) return null;
    if (grade >= 80) return '#10B981'; // green
    if (grade >= 60) return '#F59E0B'; // yellow
    return '#EF4444'; // red
  }
}

