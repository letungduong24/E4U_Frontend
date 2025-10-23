import 'package:flutter/material.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/homework_datasource.dart';
import 'package:e4uflutter/feature/schedule/data/model/homework_model.dart';

class UpcomingAssignmentsList extends StatefulWidget {
  const UpcomingAssignmentsList({super.key});

  @override
  State<UpcomingAssignmentsList> createState() => _UpcomingAssignmentsListState();
}

class _UpcomingAssignmentsListState extends State<UpcomingAssignmentsList> {
  final HomeworkDataSource _homeworkDataSource = HomeworkDataSource();
  final TokenStorage _tokenStorage = TokenStorage();
  List<HomeworkModel> _assignments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await _tokenStorage.readToken();
      
      final assignments = await _homeworkDataSource.getUpcomingAssignments(token);
      
      setState(() {
        _assignments = assignments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
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

  Widget _buildAssignmentItem(HomeworkModel assignment) {
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

}
