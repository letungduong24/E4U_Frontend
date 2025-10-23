import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/feature/schedule/data/model/schedule_model.dart';

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
  final ScheduleDataSource _scheduleDataSource = ScheduleDataSource();
  List<ScheduleModel> _schedules = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
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
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      final day = widget.selectedDate.toIso8601String().split('T')[0];
      
      final schedules = await _scheduleDataSource.getMySchedule(day, token);
      
      setState(() {
        _schedules = schedules;
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

  Widget _buildScheduleItem(ScheduleModel schedule) {
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
