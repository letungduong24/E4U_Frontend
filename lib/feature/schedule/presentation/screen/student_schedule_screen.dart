import 'package:flutter/material.dart';
import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/table_calendar_widget.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/class_schedule_list.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/upcoming_assignments_list.dart';

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({super.key});

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
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
            ClassScheduleList(selectedDate: selectedDate),
            
            const SizedBox(height: 20),
            
            // Upcoming Assignments Section
            const Text(
              'Bài tập sắp đến hạn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const UpcomingAssignmentsList(),
          ],
        ),
      ),
    );
  }
}
