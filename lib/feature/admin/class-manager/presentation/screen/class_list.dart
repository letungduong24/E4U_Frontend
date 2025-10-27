import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_management_controller.dart';
import 'package:e4uflutter/feature/admin/user-manager/presentation/controller/user_management_controller.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/create_class_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/class_profile_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/filter_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';

class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure UserManagementController is available
    Get.put(UserManagementController());
    final controller = Get.put(ClassManagementController());
    
    return HeaderScaffold(
      title: "Quản lý lớp học",
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetFilters();
          await controller.loadClasses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         kToolbarHeight - 100, // Trừ đi header và padding
            ),
            child: IntrinsicHeight(
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
                          onPressed: controller.loadClasses,
                          child: const Text("Thử lại"),
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
                            Row(
                              children: [
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
                                          onSubmitted: (value) => controller.performSearch(),
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
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
                                      SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Tên lớp",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(Icons.keyboard_arrow_up, size: 16),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Mã lớp",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(Icons.keyboard_arrow_up, size: 16),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Giáo viên",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(Icons.keyboard_arrow_up, size: 16),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Chi tiết",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.classes.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(40),
                                    child: const Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.class_outlined, size: 48, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            "Không có lớp học nào",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ...controller.classes.map((classItem) => Container(
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
                                      SizedBox(
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classItem.name,
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              classItem.description,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          classItem.code,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          classItem.homeroomTeacherName ?? 'Chưa có giáo viên',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: IconButton(
                                          onPressed: () => _showClassDetails(context, classItem),
                                          icon: Icon(
                                            Icons.visibility,
                                            size: 20,
                                            color: Colors.black87,
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
          ),
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreateClassDialog(controller: controller),
        ),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showClassDetails(BuildContext context, ClassManagementEntity classItem) {
    showDialog(
      context: context,
      builder: (context) => ClassProfileDialog(classItem: classItem),
    );
  }

  void _showFilterDialog(BuildContext context, ClassManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(controller: controller),
    );
  }

}
