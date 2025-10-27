import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleRepository {
  // Get my schedule for a specific day
  Future<List<ScheduleEntity>> getMySchedule(String day, String? token);
  
  // Get all schedules
  Future<List<ScheduleEntity>> getAllSchedules(String? token);
  
  // Get schedule by ID
  Future<ScheduleEntity> getScheduleById(String scheduleId, String? token);
  
  // Create schedule (Admin only)
  Future<ScheduleEntity> createSchedule(Map<String, dynamic> scheduleData, String? token);
  
  // Update schedule (Admin only)
  Future<ScheduleEntity> updateSchedule(String scheduleId, Map<String, dynamic> updates, String? token);
  
  // Delete schedule (Admin only)
  Future<bool> deleteSchedule(String scheduleId, String? token);
  
  // Get schedules by class
  Future<List<ScheduleEntity>> getSchedulesByClass(String classCode, String? token);
  
  // Get schedules by teacher
  Future<List<ScheduleEntity>> getSchedulesByTeacher(String teacherId, String? token);
}
