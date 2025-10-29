import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/home/data/model/home_stats_model.dart';
import 'package:e4uflutter/feature/home/data/model/upcoming_schedule_model.dart';

class HomeDatasource {
  final Dio _dio = DioClient().dio;

  Future<HomeStatsModel> getAdminDashboardStats() async {
    try {
      final response = await _dio.get('/admin/dashboard/stats');
      
      // API trả về: { "status": "success", "data": { "stats": {...} } }
      if (response.data['data'] != null && response.data['data']['stats'] != null) {
        return HomeStatsModel.fromJson(response.data['data']['stats']);
      } else {
        throw Exception('Dữ liệu không hợp lệ');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối quá thời gian. Vui lòng thử lại.');
      } else {
        String errorMessage = e.response?.data['message'] ?? 'Lấy thông tin dashboard thất bại';
        throw Exception(errorMessage);
      }
    }
  }

  Future<List<UpcomingScheduleModel>> getUpcomingSchedules() async {
    try {
      final response = await _dio.get('/schedules/upcoming');
      
      print('API Response: ${response.data}');
      
      // API trả về: { "status": "success", "data": { "schedules": [...] } }
      if (response.data['data'] != null && response.data['data']['schedules'] != null) {
        final List<dynamic> schedulesJson = response.data['data']['schedules'];
        print('Found ${schedulesJson.length} schedules');
        if (schedulesJson.isNotEmpty) {
          print('First schedule raw data: ${schedulesJson[0]}');
        }
        return schedulesJson
            .map((json) => UpcomingScheduleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Dữ liệu không hợp lệ');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối quá thời gian. Vui lòng thử lại.');
      } else {
        String errorMessage = e.response?.data['message'] ?? 'Lấy lịch học sắp tới thất bại';
        throw Exception(errorMessage);
      }
    }
  }
}

