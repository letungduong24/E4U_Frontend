import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';
import 'package:e4uflutter/feature/homework/domain/usecase/get_upcoming_assignments.dart';
import 'package:e4uflutter/feature/homework/data/repository/homework_repository_impl.dart';
import 'package:e4uflutter/feature/homework/data/datasource/homework_datasource.dart';

class UpcomingAssignmentsList extends StatefulWidget {
  const UpcomingAssignmentsList({super.key});

  @override
  State<UpcomingAssignmentsList> createState() => _UpcomingAssignmentsListState();
}

class _UpcomingAssignmentsListState extends State<UpcomingAssignmentsList> {
  late final GetUpcomingAssignments _getUpcomingAssignments;
  List<HomeworkEntity> _assignments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize use case with repository
    final repository = HomeworkRepositoryImpl(HomeworkDataSource());
    _getUpcomingAssignments = GetUpcomingAssignments(repository);
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Always use mock data for now
      setState(() {
        _assignments = _getMockAssignments();
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        _assignments = _getMockAssignments();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Lỗi tải dữ liệu: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadAssignments,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_assignments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Không có bài tập sắp đến hạn',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _assignments.map((assignment) => _buildAssignmentItem(assignment)).toList(),
    );
  }

  Widget _buildAssignmentItem(HomeworkEntity assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assignment title
          Text(
            assignment.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Due date and view icon
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                'Ngày đến hạn: ${assignment.formattedDeadline}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle view assignment details
                },
                child: const Icon(
                  Icons.visibility,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<HomeworkEntity> _getMockAssignments() {
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
