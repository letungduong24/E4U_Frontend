import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_students_controller.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/class_student_profile_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/update_class_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/assign_student_dialog.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_management_controller.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:intl/intl.dart';

class ClassStudentsScreen extends StatelessWidget {
  const ClassStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClassStudentsController());
    final classController = Get.find<ClassManagementController>();
    
    return HeaderScaffold(
      title: controller.className.value,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshStudents();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class Information Section
                Obx(() => _buildClassInfoSection(context, controller, classController)),
                
                const SizedBox(height: 24),
                
                // Student List Section
                _buildStudentListSection(context, controller),
              ],
            ),
          ),
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context, controller, classController),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildClassInfoSection(BuildContext context, ClassStudentsController controller, ClassManagementController classController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giáo viên: Nguyễn Thị C", // TODO: Get actual teacher name
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Mã lớp: ${controller.classCode.value}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Số HS tối đa: ${controller.maxStudents.value}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Số HS hiện tại: ${controller.students.length}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Edit and Delete buttons
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _showEditClassDialog(context, classController),
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _showDeleteClassDialog(context, classController),
                      icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListSection(BuildContext context, ClassStudentsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Danh sách học sinh",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Students Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ));
            }
            
            if (controller.error.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
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
                        onPressed: controller.loadClassStudents,
                        child: const Text("Thử lại"),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
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
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                const Text(
                                  "Điểm trung bình",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_up, size: 16),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Xem chi tiết",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Students Rows
                    if (controller.filteredStudents.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(Icons.people_outline, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "Không có học sinh nào",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...controller.filteredStudents.map((student) => Container(
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
                              child: Text(
                                student.fullName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                "8.5", // TODO: Get actual average score
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: IconButton(
                                onPressed: () => _showStudentDetails(context, student),
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
            );
          }),
        ),
      ],
    );
  }

  void _showStudentDetails(BuildContext context, ClassStudentEntity student) {
    showDialog(
      context: context,
      builder: (context) => ClassStudentProfileDialog(student: student),
    );
  }

  void _showEditClassDialog(BuildContext context, ClassManagementController classController) {
    // Get the current class data
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) return;
    
    final classId = arguments['classId'] as String?;
    if (classId == null) return;
    
    // Find the class in the controller
    final classItem = classController.classes.firstWhereOrNull((c) => c.id == classId);
    if (classItem == null) return;
    
    showDialog(
      context: context,
      builder: (context) => UpdateClassDialog(
        controller: classController,
        classItem: classItem,
      ),
    );
  }

  void _showDeleteClassDialog(BuildContext context, ClassManagementController classController) {
    // Get the current class data
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) return;
    
    final classId = arguments['classId'] as String?;
    if (classId == null) return;
    
    // Find the class in the controller
    final classItem = classController.classes.firstWhereOrNull((c) => c.id == classId);
    if (classItem == null) return;
    
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: "lớp học",
        deleteFunction: () async {
          await classController.deleteClass(classItem.id);
          Navigator.pop(context); // Close confirmation dialog
          Navigator.pop(context); // Go back to class list
        },
        controller: classController,
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context, ClassStudentsController controller, ClassManagementController classController) {
    // Get the current class data
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) return;
    
    final classId = arguments['classId'] as String?;
    if (classId == null) return;
    
    // Find the class in the controller
    final classItem = classController.classes.firstWhereOrNull((c) => c.id == classId);
    if (classItem == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AssignStudentDialog(
        controller: controller,
        classItem: classItem,
      ),
    );
  }

}
