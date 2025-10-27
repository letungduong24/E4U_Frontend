import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';
import 'package:e4uflutter/feature/auth/data/model/user_model.dart';

class AuthDatasource{
  final Dio _dio = DioClient().dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      await _tokenStorage.writeToken(response.data['data']['token']);
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối quá thời gian. Vui lòng thử lại.');
      } else {
        String errorMessage = e.response?.data['message'] ?? 'Đăng nhập thất bại';
        
        // Dịch các lỗi phổ biến sang tiếng Việt
        if (errorMessage.contains('Invalid credentials') || errorMessage.contains('invalid credentials')) {
          errorMessage = 'Email hoặc mật khẩu không đúng';
        } else if (errorMessage.contains('Validation failed')) {
          errorMessage = 'Thông tin không hợp lệ';
        }
        
        throw Exception(errorMessage);
      }
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy thông tin người dùng thất bại');
    }
  }
  
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? avatar,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? address,
    bool? notification,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      
      final profileData = <String, dynamic>{};
      if (avatar != null) profileData['avatar'] = avatar;
      if (phone != null) profileData['phone'] = phone;
      if (dateOfBirth != null) profileData['dateOfBirth'] = dateOfBirth;
      if (gender != null) profileData['gender'] = gender;
      if (address != null) profileData['address'] = address;
      if (notification != null) profileData['notification'] = notification;
      
      if (profileData.isNotEmpty) {
        data['profile'] = profileData;
      }
      
      print('Updating profile with data: $data');
      final response = await _dio.put('/auth/updateprofile', data: data);
      
      print('Update profile response: ${response.data}');
      print('Response data structure: ${response.data}');
      
      // Handle response structure
      if (response.data['data'] != null && response.data['data']['user'] != null) {
        return UserModel.fromJson(response.data['data']['user']);
      } else if (response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        // If structure is different, try to parse directly
        return UserModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      print('Error updating profile: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Cập nhật profile thất bại');
    } catch (e) {
      print('Error in updateProfile: $e');
      rethrow;
    }
  }

}