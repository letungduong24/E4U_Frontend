import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/usecase/get_class_homework.dart';
import 'package:e4uflutter/feature/homework/domain/usecase/create_homework.dart';
import 'package:e4uflutter/feature/homework/domain/usecase/update_homework.dart';
import 'package:e4uflutter/feature/homework/domain/usecase/delete_homework.dart';
import 'package:e4uflutter/feature/homework/data/repository/homework_repository_impl.dart';
import 'package:e4uflutter/feature/homework/data/datasource/homework_datasource.dart';

class HomeworkController extends GetxController {
  // Observable state
  final RxList<HomeworkEntity> homeworks = <HomeworkEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedClass = 'TA1'.obs;
  final RxString teacherName = 'Lê Hùng A'.obs;

  // Dependencies
  late final GetClassHomework _getClassHomework;
  late final CreateHomework _createHomework;
  late final UpdateHomework _updateHomework;
  late final DeleteHomework _deleteHomework;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    loadHomeworks();
  }

  void _initializeDependencies() {
    final repository = HomeworkRepositoryImpl(HomeworkDataSource());
    _getClassHomework = GetClassHomework(repository);
    _createHomework = CreateHomework(repository);
    _updateHomework = UpdateHomework(repository);
    _deleteHomework = DeleteHomework(repository);
  }

  Future<void> loadHomeworks() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Always use mock data for now
      homeworks.value = _getMockHomeworks();
      
    } catch (e) {
      error.value = 'Failed to load homeworks: $e';
      // Fallback to mock data
      homeworks.value = _getMockHomeworks();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createHomework(Map<String, dynamic> homeworkData) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      
      if (token != null) {
        await _createHomework(homeworkData, token);
        await loadHomeworks(); // Refresh list
      }
    } catch (e) {
      error.value = 'Failed to create homework: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateHomework(String homeworkId, Map<String, dynamic> updates) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      
      if (token != null) {
        await _updateHomework(homeworkId, updates, token);
        await loadHomeworks(); // Refresh list
      }
    } catch (e) {
      error.value = 'Failed to update homework: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHomework(String homeworkId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      
      if (token != null) {
        await _deleteHomework(homeworkId, token);
        await loadHomeworks(); // Refresh list
      }
    } catch (e) {
      error.value = 'Failed to delete homework: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedClass(String classId) {
    selectedClass.value = classId;
    loadHomeworks();
  }

  List<HomeworkEntity> get filteredHomeworks {
    if (searchQuery.value.isEmpty) {
      return homeworks;
    }
    return homeworks.where((homework) =>
        homework.title.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  List<HomeworkEntity> _getMockHomeworks() {
    return [
      HomeworkEntity(
        id: '1',
        classId: 'TA1',
        className: 'Lớp TA1',
        title: 'Bài tập về Tense',
        description: 'Bài tập này giúp các em ôn lại các thì trong tiếng Anh',
        deadline: DateTime(2025, 9, 10),
        fileName: 'tense_exercise.pdf',
        filePath: '/files/tense_exercise.pdf',
        attachmentUrl: 'https://example.com/tense_exercise.pdf',
        attachmentName: 'tense_exercise.pdf',
        teacherId: 'teacher1',
        teacherName: 'Lê Hùng A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      HomeworkEntity(
        id: '2',
        classId: 'TA1',
        className: 'Lớp TA1',
        title: 'Bài tập V-ing',
        description: 'Bài tập về động từ thêm -ing',
        deadline: DateTime(2025, 9, 6),
        fileName: 'ving_exercise.pdf',
        filePath: '/files/ving_exercise.pdf',
        attachmentUrl: 'https://example.com/ving_exercise.pdf',
        attachmentName: 'ving_exercise.pdf',
        teacherId: 'teacher1',
        teacherName: 'Lê Hùng A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
