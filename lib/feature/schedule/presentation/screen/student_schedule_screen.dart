import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/table_calendar_widget.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/student_schedule_list.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/student_schedule_controller.dart';

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({super.key});

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  late final StudentScheduleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StudentScheduleController());
    _loadSchedulesForDate(selectedDate);
  }

  void _loadSchedulesForDate(DateTime date) {
    controller.loadSchedules(date);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Lịch học',
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
            
            // Class Schedule Section
            const Text(
              'Giờ học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            StudentScheduleList(selectedDate: selectedDate),
          ],
        ),
      ),
    );
  }
}
