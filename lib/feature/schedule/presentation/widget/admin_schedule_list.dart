import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/domain/usecase/get_my_schedule.dart';
import 'package:e4uflutter/feature/schedule/data/repository/schedule_repository_impl.dart';
import 'package:e4uflutter/feature/schedule/data/datasource/schedule_datasource.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/schedule_modal.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/delete_confirm_modal.dart';
import 'package:e4uflutter/shared/presentation/widget/schedule_success_popup.dart';

class AdminScheduleList extends StatefulWidget {
  final DateTime selectedDate;

  const AdminScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AdminScheduleList> createState() => _AdminScheduleListState();
}

class _AdminScheduleListState extends State<AdminScheduleList> {
  late final GetMySchedule _getMySchedule;
  List<ScheduleEntity> _schedules = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize use case with repository
    final repository = ScheduleRepositoryImpl(ScheduleDataSource());
    //_getMySchedule = GetMySchedule(repository);
    _loadSchedules();
  }

  @override
  void didUpdateWidget(AdminScheduleList oldWidget) {
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
        _schedules = _getMockSchedules(widget.selectedDate);
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      // Fallback to mock data
      setState(() {
        _schedules = _getMockSchedules(widget.selectedDate);
        _isLoading = false;
        _error = null;
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
      children: _schedules.map((schedule) => _buildScheduleItem(schedule, context)).toList(),
    );
  }

  Widget _buildScheduleItem(ScheduleEntity schedule, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Lighter gray background
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
          
          const SizedBox(width: 12),
          
          // Edit button
          GestureDetector(
            onTap: () => _showEditScheduleModal(context, schedule),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9500), // Orange color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Delete button
          GestureDetector(
            onTap: () => _showDeleteConfirmModal(context, schedule),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE74C3C), // Red color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          
          // Add right padding to match left padding
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  void _showEditScheduleModal(BuildContext context, ScheduleEntity schedule) {
    showDialog(
      context: context,
      builder: (context) => ScheduleModal(
        mode: ScheduleModalMode.update,
        initialClassCode: schedule.classCode,
        initialTime: schedule.formattedTime,
        onSave: (classCode, time) {
          // Handle update schedule
          Navigator.of(context).pop();
          // Show success popup
          showDialog(
            context: context,
            builder: (context) => ScheduleSuccessPopup(
              title: 'Sửa lịch thành công',
              message: 'Lịch học đã được cập nhật thành công.',
              primaryButtonText: 'Xem lịch',
              secondaryButtonText: 'Đóng',
              onPrimaryPressed: () => Navigator.of(context).pop(),
              onSecondaryPressed: () => Navigator.of(context).pop(),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmModal(BuildContext context, ScheduleEntity schedule) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trash Icon
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red[600],
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Xoá lịch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bạn có chắc chắn muốn xóa lịch này?\nThao tác này không thể hoàn tác.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Column(
                children: [
                  // Delete Button (Primary)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Show success popup
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Success Icon
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green[600],
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Title
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Xóa lịch thành công',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Message
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Lịch học đã được xóa thành công.',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Single Close Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Đóng',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xoá',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button (Secondary)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Huỷ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ScheduleEntity> _getMockSchedules(DateTime date) {
    // Mock data - replace with actual API call
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Hiển thị lịch dạy cho ngày hôm nay và một số ngày khác
    if (selectedDate.isAtSameMomentAs(todayDate)) {
      return [
        ScheduleEntity(
          id: '1',
          classCode: 'TA1',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 18, 30),
          endTime: DateTime(date.year, date.month, date.day, 20, 30),
          dayOfWeek: 'Monday',
          room: 'Room 101',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ScheduleEntity(
          id: '2',
          classCode: 'TA2',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 18, 30),
          endTime: DateTime(date.year, date.month, date.day, 20, 30),
          dayOfWeek: 'Monday',
          room: 'Room 102',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ScheduleEntity(
          id: '3',
          classCode: 'TA3',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 18, 30),
          endTime: DateTime(date.year, date.month, date.day, 20, 30),
          dayOfWeek: 'Monday',
          room: 'Room 103',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } else if (date.day == 10) {
      return [
        ScheduleEntity(
          id: '4',
          classCode: 'TA1',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 14, 0),
          endTime: DateTime(date.year, date.month, date.day, 16, 0),
          dayOfWeek: 'Tuesday',
          room: 'Room 101',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ScheduleEntity(
          id: '5',
          classCode: 'TA2',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 16, 30),
          endTime: DateTime(date.year, date.month, date.day, 18, 30),
          dayOfWeek: 'Tuesday',
          room: 'Room 102',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } else if (date.day == 11) {
      return [
        ScheduleEntity(
          id: '6',
          classCode: 'TA1',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 9, 0),
          endTime: DateTime(date.year, date.month, date.day, 11, 0),
          dayOfWeek: 'Wednesday',
          room: 'Room 101',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ScheduleEntity(
          id: '7',
          classCode: 'TA3',
          subject: 'Tiếng Anh',
          teacherId: 'teacher1',
          startTime: DateTime(date.year, date.month, date.day, 13, 0),
          endTime: DateTime(date.year, date.month, date.day, 15, 0),
          dayOfWeek: 'Wednesday',
          room: 'Room 103',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    return [];
  }
}
