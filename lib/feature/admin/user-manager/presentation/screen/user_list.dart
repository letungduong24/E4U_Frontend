import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/user-manager/presentation/controller/user_management_controller.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/shared/presentation/button.dart';
import 'package:e4uflutter/shared/utils/role_util.dart';
import 'package:intl/intl.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserManagementController());
    
    return HeaderScaffold(
      title: "Quản lý người dùng",
      body: Column(
        children: [
          
          // Users Table
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Có lỗi xảy ra: ${controller.error.value}",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.loadUsers,
                        child: const Text("Thử lại"),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.users.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Không có người dùng nào",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Table Header with Search and Filter
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Search and Filter Row
                          Row(
                            children: [
                              // Filter Button
                              GestureDetector(
                                onTap: () => _showFilterDialog(context, controller),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[200]!, width: 0.5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Lọc",
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Search Input
                              Expanded(
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[200]!, width: 0.5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          onChanged: controller.setSearchQuery,
                                          style: const TextStyle(fontSize: 14, height: 1.0),
                                          decoration: const InputDecoration(
                                            hintText: "Tìm kiếm",
                                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey, height: 1.0),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Table Rows
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              // Column Headers Row
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Tên
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Tên",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.keyboard_arrow_up, size: 16),
                                        ],
                                      ),
                                    ),
                                    // Lớp
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Lớp",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.keyboard_arrow_up, size: 16),
                                        ],
                                      ),
                                    ),
                                    // Vai trò
                                    SizedBox(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Vai trò",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.keyboard_arrow_up, size: 16),
                                        ],
                                      ),
                                    ),
                                    // Xem chi tiết
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "Chi tiết",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Data Rows
                              ...controller.users.map((user) => Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Tên
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.fullName,
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Lớp
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        _getClassDisplay(user),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    // Vai trò
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        RoleUtil.GetRoleDisplayName(user.role),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // Xem chi tiết
                                    SizedBox(
                                      width: 80,
                                      child: IconButton(
                                        onPressed: () => _showUserDetails(context, user),
                                        icon: Icon(
                                          Icons.visibility,
                                          size: 20,
                                          color: Colors.blue[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => _showCreateUserDialog(context, controller),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getClassDisplay(user) {
    if (user.role == 'student' && user.currentClass != null) {
      return user.currentClass!;
    } else if (user.role == 'teacher' && user.teachingClass != null) {
      return user.teachingClass!;
    } else {
      return 'Chưa có lớp';
    }
  }

  void _showUserDetails(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${user.email}"),
            Text("Vai trò: ${RoleUtil.GetRoleDisplayName(user.role)}"),
            if (user.currentClass != null) Text("Lớp: ${user.currentClass}"),
            if (user.teachingClass != null) Text("Lớp dạy: ${user.teachingClass}"),
            Text("Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(user.createdAt)}"),
            if (user.lastLoginAt != null) 
              Text("Đăng nhập cuối: ${DateFormat('dd/MM/yyyy HH:mm').format(user.lastLoginAt!)}"),
            Text("Trạng thái: ${user.isActive ? 'Hoạt động' : 'Không hoạt động'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, UserManagementController controller) {
    String selectedRole = controller.selectedRole.value;
    String selectedClass = controller.selectedClass.value;
    bool showActiveOnly = controller.showActiveOnly.value;
    String sortBy = controller.sortBy.value;
    String sortOrder = controller.sortOrder.value;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bộ lọc và sắp xếp"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Role Filter
            DropdownButtonFormField<String>(
              value: selectedRole.isEmpty ? null : selectedRole,
              decoration: const InputDecoration(
                labelText: "Vai trò",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('Tất cả')),
                DropdownMenuItem(value: 'student', child: Text('Học viên')),
                DropdownMenuItem(value: 'teacher', child: Text('Giáo viên')),
                DropdownMenuItem(value: 'admin', child: Text('Quản trị viên')),
              ],
              onChanged: (value) => selectedRole = value ?? '',
            ),
            const SizedBox(height: 16),
            
            // Class Filter
            TextField(
              decoration: const InputDecoration(
                labelText: "Lớp học",
                border: OutlineInputBorder(),
                hintText: "Nhập tên lớp để lọc",
              ),
              onChanged: (value) => selectedClass = value,
            ),
            const SizedBox(height: 16),
            
            // Active Status Filter
            CheckboxListTile(
              title: const Text("Chỉ hiển thị người dùng hoạt động"),
              value: showActiveOnly,
              onChanged: (value) => showActiveOnly = value ?? false,
            ),
            const SizedBox(height: 16),
            
            // Sort By
            DropdownButtonFormField<String>(
              value: sortBy,
              decoration: const InputDecoration(
                labelText: "Sắp xếp theo",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'createdAt', child: Text('Ngày tạo')),
                DropdownMenuItem(value: 'fullName', child: Text('Tên')),
                DropdownMenuItem(value: 'email', child: Text('Email')),
              ],
              onChanged: (value) => sortBy = value ?? 'createdAt',
            ),
            const SizedBox(height: 16),
            
            // Sort Order
            DropdownButtonFormField<String>(
              value: sortOrder,
              decoration: const InputDecoration(
                labelText: "Thứ tự",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
                DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
              ],
              onChanged: (value) => sortOrder = value ?? 'desc',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Navigator.pop(context);
            },
            child: const Text("Xóa bộ lọc"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.setSelectedRole(selectedRole);
              controller.setSelectedClass(selectedClass);
              controller.setShowActiveOnly(showActiveOnly);
              controller.setSorting(sortBy, sortOrder);
              Navigator.pop(context);
            },
            child: const Text("Áp dụng"),
          ),
        ],
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context, UserManagementController controller) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'student';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tạo người dùng mới"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: "Vai trò",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Học viên')),
                DropdownMenuItem(value: 'teacher', child: Text('Giáo viên')),
                DropdownMenuItem(value: 'admin', child: Text('Quản trị viên')),
              ],
              onChanged: (value) => selectedRole = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final nameParts = nameController.text.split(' ');
                final firstName = nameParts.first;
                final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
                
                controller.createUser(
                  firstName: firstName,
                  lastName: lastName,
                  email: emailController.text,
                  role: selectedRole,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Tạo"),
          ),
        ],
      ),
    );
  }
}
