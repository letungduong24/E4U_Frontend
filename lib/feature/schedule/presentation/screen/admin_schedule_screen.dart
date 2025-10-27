import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/table_calendar_widget.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/admin_schedule_list.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/create_schedule_dialog.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/admin_schedule_controller.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  late final AdminScheduleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AdminScheduleController());
    _loadSchedulesForDate(selectedDate);
  }

  void _loadSchedulesForDate(DateTime date) {
    controller.loadSchedules(date);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Quản lý lịch',
      floatingButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleModal();
        },
        backgroundColor: const Color(0xFF3396D3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Calendar Widget
            TableCalendarWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                _loadSchedulesForDate(date);
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
    );
  }

  void _showAddScheduleModal() {
    showDialog(
      context: context,
      builder: (context) => const CreateScheduleDialog(),
    );
  }
}
