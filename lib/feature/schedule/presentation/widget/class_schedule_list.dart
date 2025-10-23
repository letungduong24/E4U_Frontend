import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/usecase/get_my_schedule.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';

class ClassScheduleList extends StatefulWidget {
  final DateTime selectedDate;

  const ClassScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ClassScheduleList> createState() => _ClassScheduleListState();
}

class _ClassScheduleListState extends State<ClassScheduleList> {
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
  void didUpdateWidget(ClassScheduleList oldWidget) {
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
            'Không có lịch học trong ngày này',
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

  List<ScheduleEntity> _getMockSchedules() {
    final now = DateTime.now();
    return [
      ScheduleEntity(
        id: '1',
        classCode: 'TA1',
        subject: 'Tiếng Anh',
        teacherId: 'teacher1',
        teacherName: 'Lê Hùng A',
        startTime: DateTime(now.year, now.month, now.day, 8, 0), // 08:00
        endTime: DateTime(now.year, now.month, now.day, 9, 30), // 09:30
        dayOfWeek: '2', // Monday
        room: 'Phòng A101',
        description: 'Lớp học tiếng Anh cơ bản',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ScheduleEntity(
        id: '2',
        classCode: 'TA1',
        subject: 'Toán học',
        teacherId: 'teacher2',
        teacherName: 'Nguyễn Văn B',
        startTime: DateTime(now.year, now.month, now.day, 10, 0), // 10:00
        endTime: DateTime(now.year, now.month, now.day, 11, 30), // 11:30
        dayOfWeek: '2', // Monday
        room: 'Phòng A102',
        description: 'Lớp học toán cơ bản',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
