import 'package:e4uflutter/feature/homework/domain/entity/homework_entity.dart';

abstract class HomeworkRepository {
  // Get upcoming assignments
  Future<List<HomeworkEntity>> getUpcomingAssignments(String? token);
  
  // Get overdue assignments
  Future<List<HomeworkEntity>> getOverdueAssignments(String? token);
  
  // Get all homework assignments
  Future<List<HomeworkEntity>> getAllHomework(String? token);
  
  // Get homework by ID
  Future<HomeworkEntity> getHomeworkById(String homeworkId, String? token);
  
  // Get homework by class ID
  Future<List<HomeworkEntity>> getClassHomework(String classId, String? token);
  
  // Create homework (Teacher only)
  Future<HomeworkEntity> createHomework(Map<String, dynamic> homeworkData, String? token);
  
  // Update homework (Teacher only)
  Future<HomeworkEntity> updateHomework(String homeworkId, Map<String, dynamic> updates, String? token);
  
  // Delete homework (Teacher only)
  Future<bool> deleteHomework(String homeworkId, String? token);
}
