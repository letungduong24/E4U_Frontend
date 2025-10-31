import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleRepository {
  // Get my schedule for a specific day
  Future<List<ScheduleEntity>> getMySchedule(String day);
  
  // Get all schedules
  Future<List<ScheduleEntity>> getAllSchedules();
  
  // Get schedule by ID
  Future<ScheduleEntity> getScheduleById(String scheduleId);
  
  // Create schedule (Admin only)
  Future<ScheduleEntity> createSchedule(Map<String, dynamic> scheduleData);
  
  // Update schedule (Admin only)
  Future<ScheduleEntity> updateSchedule(String scheduleId, Map<String, dynamic> updates);
  
  // Delete schedule (Admin only)
  Future<bool> deleteSchedule(String scheduleId);
  
  // Get schedules by class
  Future<List<ScheduleEntity>> getSchedulesByClass(String classCode);
  
  // Get schedules by teacher
  Future<List<ScheduleEntity>> getSchedulesByTeacher(String teacherId);
}
