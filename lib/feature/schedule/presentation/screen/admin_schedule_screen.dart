import 'package:flutter/material.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/table_calendar_widget.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/admin_schedule_list.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/schedule_modal.dart';
import 'package:e4uflutter/shared/presentation/widget/schedule_success_popup.dart';
import 'package:e4uflutter/shared/presentation/widget/header_actions.dart';
import 'package:e4uflutter/shared/presentation/drawer/admin_drawer.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Quản lý lịch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const HeaderActions(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Table Calendar Widget
            TableCalendarWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Teaching Schedule Section
            const Text(
              'Tiết học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            AdminScheduleList(selectedDate: selectedDate),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleModal();
        },
        backgroundColor: const Color(0xFF3396D3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddScheduleModal() {
    showDialog(
      context: context,
      builder: (context) => ScheduleModal(
        mode: ScheduleModalMode.create,
        onSave: (classCode, time) {
          // Handle create schedule
          Navigator.of(context).pop();
          // Show success popup
          showDialog(
            context: context,
            builder: (context) => ScheduleSuccessPopup(
              title: 'Tạo lịch thành công',
              message: 'Lịch học đã được tạo thành công.',
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
}
