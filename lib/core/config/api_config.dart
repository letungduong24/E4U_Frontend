class ApiConfig {
  // Base URL for API
  static const String baseUrl = 'http://localhost:5000/api';
  
  // API Endpoints
  static const String schedules = '/schedules';
  static const String homeworks = '/homeworks';
  static const String auth = '/auth';
  
  // Schedule endpoints
  static String mySchedule(String day) => '$schedules/my-schedule?day=$day';
  static String upcomingSchedules = '$schedules/upcoming';
  static String scheduleById(String id) => '$schedules/$id';
  
  // Homework endpoints
  static String upcomingAssignments = '$homeworks/upcoming';
  static String overdueAssignments = '$homeworks/overdue';
  static String homeworkById(String id) => '$homeworks/$id';
  
  // Headers
  static Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
