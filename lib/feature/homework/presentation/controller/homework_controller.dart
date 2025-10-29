import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/data/datasource/homework_datasource.dart';
import 'package:e4uflutter/feature/homework/data/repository/homework_repository_impl.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/submission/data/datasource/submission_datasource.dart';
import 'package:e4uflutter/feature/submission/data/repository/submission_repository_impl.dart';
import 'package:e4uflutter/feature/submission/domain/entity/submission_entity.dart';

class HomeworkController extends GetxController {
  final RxList<HomeworkEntity> homeworks = <HomeworkEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedClass = ''.obs;
  final RxString sortBy = 'deadline'.obs;
  final RxString sortOrder = 'asc'.obs;
  final RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  
  // Submissions for homework detail
        final RxList<SubmissionEntity> submissions = <SubmissionEntity>[].obs;
        final RxBool isLoadingSubmissions = false.obs;
        final Rx<SubmissionEntity?> studentSubmission = Rx<SubmissionEntity?>(null);
        final RxBool isLoadingStudentSubmission = false.obs;

  late final HomeworkRepositoryImpl _repository;
  late final SubmissionRepositoryImpl _submissionRepository;

  @override
  void onInit() {
    super.onInit();
    final datasource = HomeworkDatasource();
    _repository = HomeworkRepositoryImpl(datasource);
    
    final submissionDatasource = SubmissionDatasource();
    _submissionRepository = SubmissionRepositoryImpl(submissionDatasource);
    
    loadHomeworks();
    loadClasses();
  }

  Future<void> loadHomeworks() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _repository.getAllHomeworks(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        classFilter: selectedClass.value.isEmpty ? null : selectedClass.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );
      homeworks.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSubmissionsByHomework(String homeworkId) async {
    try {
      isLoadingSubmissions.value = true;
      error.value = '';
      final result = await _submissionRepository.getSubmissionsByHomeworkId(homeworkId);
      submissions.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingSubmissions.value = false;
    }
  }

  Future<void> createHomework({
    required String title,
    required String description,
    required DateTime deadline,
    String? filePath,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.createHomework(
        title: title,
        description: description,
        deadline: deadline,
        filePath: filePath,
      );
      await loadHomeworks();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateHomework(
    String homeworkId, {
    String? title,
    String? description,
    DateTime? deadline,
    String? filePath,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.updateHomework(
        homeworkId,
        title: title,
        description: description,
        deadline: deadline,
        filePath: filePath,
      );
      await loadHomeworks();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHomework(String homeworkId) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.deleteHomework(homeworkId);
      await loadHomeworks();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) => searchQuery.value = query;
  void performSearch() => loadHomeworks();
  void setSelectedClass(String classId) {
    selectedClass.value = classId;
    loadHomeworks();
  }
  void setSorting(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    loadHomeworks();
  }
  void clearFilters() {
    searchQuery.value = '';
    selectedClass.value = '';
    sortBy.value = 'deadline';
    sortOrder.value = 'asc';
    loadHomeworks();
  }
  void resetFilters() {
    searchQuery.value = '';
    selectedClass.value = '';
    sortBy.value = 'deadline';
    sortOrder.value = 'asc';
  }
  Future<void> loadClasses() async {
    try {
      final classesList = await _repository.getClasses();
      classes.value = classesList;
    } catch (e) {
      print('Error loading classes: $e');
    }
  }

  Future<void> loadStudentSubmissionByHomework(String homeworkId) async {
    try {
      isLoadingStudentSubmission.value = true;
      error.value = '';
      final result = await _submissionRepository.getStudentSubmissionByHomeworkId(homeworkId);
      studentSubmission.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingStudentSubmission.value = false;
    }
  }

  Future<void> submitHomework({
    required String homeworkId,
    required String file,
  }) async {
    try {
      isLoadingStudentSubmission.value = true;
      error.value = '';
      final result = await _submissionRepository.submitHomework(
        homeworkId: homeworkId,
        file: file,
      );
      studentSubmission.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingStudentSubmission.value = false;
    }
  }

  Future<void> updateSubmission({
    required String submissionId,
    required String file,
  }) async {
    try {
      isLoadingStudentSubmission.value = true;
      error.value = '';
      final result = await _submissionRepository.updateSubmission(
        submissionId: submissionId,
        file: file,
      );
      studentSubmission.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingStudentSubmission.value = false;
    }
  }

  Future<void> deleteSubmission(String submissionId) async {
    try {
      isLoadingStudentSubmission.value = true;
      error.value = '';
      await _submissionRepository.deleteSubmission(submissionId);
      studentSubmission.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingStudentSubmission.value = false;
    }
  }

  Future<void> gradeSubmission({
    required String submissionId,
    required int grade,
    String? feedback,
  }) async {
    try {
      isLoadingSubmissions.value = true;
      error.value = '';
      await _submissionRepository.gradeSubmission(
        submissionId: submissionId,
        grade: grade,
        feedback: feedback,
      );
      // Reload submissions to get updated data
      await loadSubmissionsByHomework(submissions.first.homeworkId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingSubmissions.value = false;
    }
  }
}
