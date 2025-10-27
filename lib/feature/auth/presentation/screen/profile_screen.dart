import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/auth/presentation/widget/update_profile_dialog.dart';
import 'package:e4uflutter/shared/presentation/button.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/shared/utils/role_util.dart';
import 'package:e4uflutter/shared/utils/status_util.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  
  Future<void> _showAvatarDialog(String avatarUrl) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image == null) return;
      
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Upload to Cloudinary
      print('Uploading image to Cloudinary...');
      final imageUrl = await _uploadToCloudinary(File(image.path));
      print('Image uploaded successfully. URL: $imageUrl');
      
      // Update profile with the returned URL
      await _updateProfileAvatar(imageUrl);
      
      if (mounted) {
        Navigator.pop(context); // Close loading
        showDialog(
          context: context,
          builder: (context) => const SuccessDialog(
            title: 'Cập nhật avatar thành công',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Lỗi"),
            content: Text('Lỗi: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }
  
  Future<String> _uploadToCloudinary(File imageFile) async {
    const cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dfemfoftc/image/upload';
    const uploadPreset = 'flutter';
    
    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    
    var response = await request.send();
    
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      // Get secure_url from Cloudinary response
      return jsonResponse['secure_url'] as String;
    } else {
      var errorData = await response.stream.bytesToString();
      throw Exception('Upload failed: $errorData');
    }
  }
  
  Future<void> _updateProfileAvatar(String avatarUrl) async {
    final controller = Get.find<AuthController>();
    await controller.updateProfile(avatar: avatarUrl);
  }
  
  void _showUpdateProfileDialog(BuildContext context) {
    final user = AuthController.user.value;
    if (user == null) return;
    
    final controller = Get.find<AuthController>();
    
    showDialog(
      context: context,
      builder: (context) => UpdateProfileDialog(
        user: user,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: "Trang cá nhân",
      body: Center(
        child: Obx(() {
          final user = AuthController.user.value;
          final avatarUrl = user?.profile?.avatar;
          final birthOfDate = user?.profile?.dateOfBirth != null
              ? DateFormat('dd/MM/yyyy').format(user!.profile!.dateOfBirth!)
              : "Chưa cập nhật";
          final phoneNumber = user?.profile?.phone ?? "Chưa cập nhật";
          final address = user?.profile?.address ?? "Chưa cập nhật";

          return Column(
            children: [
              // Avatar + Basic info
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: avatarUrl != null && avatarUrl.isNotEmpty
                              ? () => _showAvatarDialog(avatarUrl)
                              : null,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              image: DecorationImage(
                                image: avatarUrl != null && avatarUrl.isNotEmpty
                                    ? NetworkImage(avatarUrl)
                                    : const AssetImage('assets/images/default_avatar.jpg')
                                as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: _pickAndUploadImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user != null ? user.fullName : "Người dùng",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user != null
                              ? RoleUtil.GetRoleTitle(user)
                              : "Người dùng",
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //Detail info section
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Email:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            user?.email ?? "Chưa cập nhật",
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ngày sinh:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          birthOfDate,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          phoneNumber,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Địa chỉ:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          address,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: DefaultButton(
                        text: "Sửa thông tin",
                        borderRadius: 20,
                        onPressed: () => _showUpdateProfileDialog(context),
                      ),
                    ),
                  ],
                )
              ),
            ],
          );
        }),
      ),
    );
  }
}
