import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/usecase/get_my_schedule.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';

class TeacherScheduleList extends StatefulWidget {
  final DateTime selectedDate;

  const TeacherScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  State<TeacherScheduleList> createState() => _TeacherScheduleListState();
}

class _TeacherScheduleListState extends State<TeacherScheduleList> {
  late final GetMySchedule _getMySchedule;
  List<ScheduleEntity> _schedules = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize use case with repository
    final repository = ScheduleRepositoryImpl(ScheduleDataSource());
    _getMySchedule = GetMySchedule(repository);
    _loadSchedules();
  }

  @override
  void didUpdateWidget(TeacherScheduleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadSchedules();
    }
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Always use mock data for now
      setState(() {
        _schedules = _getMockSchedules();
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        _schedules = _getMockSchedules();
        _isLoading = false;
      });
    }
  }

  List<ScheduleEntity> _getMockSchedules() {
    return [
      ScheduleEntity(
        id: '1',
        classCode: 'TA1',
        subject: 'Toán học',
        teacherId: 'teacher1',
        teacherName: 'Nguyễn Văn A',
        startTime: DateTime.now().copyWith(hour: 8, minute: 0),
        endTime: DateTime.now().copyWith(hour: 9, minute: 30),
        dayOfWeek: widget.selectedDate.weekday.toString(),
        room: 'A101',
        description: 'Bài học về đại số',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ScheduleEntity(
        id: '2',
        classCode: 'TA2',
        subject: 'Vật lý',
        teacherId: 'teacher1',
        teacherName: 'Nguyễn Văn A',
        startTime: DateTime.now().copyWith(hour: 10, minute: 0),
        endTime: DateTime.now().copyWith(hour: 11, minute: 30),
        dayOfWeek: widget.selectedDate.weekday.toString(),
        room: 'B202',
        description: 'Bài học về cơ học',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
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
              onPressed: _loadSchedules,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_schedules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Không có lịch dạy trong ngày này',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _schedules.map((schedule) => _buildScheduleItem(schedule)).toList(),
    );
  }

  Widget _buildScheduleItem(ScheduleEntity schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Light gray background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Class code
          Expanded(
            child: Text(
              schedule.classCode,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          // Time badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3396D3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              schedule.formattedTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
