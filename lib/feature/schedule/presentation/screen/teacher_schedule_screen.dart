import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
// import 'package:e4uflutter/shared/presentation/widget/header_actions.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/table_calendar_widget.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/teacher_schedule_list.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/teacher_schedule_controller.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  late final TeacherScheduleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TeacherScheduleController());
    _loadSchedulesForDate(selectedDate);
  }

  void _loadSchedulesForDate(DateTime date) {
    controller.loadSchedules(date);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Lịch dạy',
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
              'Lịch dạy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TeacherScheduleList(selectedDate: selectedDate),
          ],
        ),
      ),
    );
  }
}
