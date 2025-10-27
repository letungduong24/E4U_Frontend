import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/create_homework_dialog.dart';
import 'package:e4uflutter/shared/presentation/scaffold/header_scaffold.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:intl/intl.dart';

class HomeworkListScreen extends StatelessWidget {
  const HomeworkListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeworkController());
    
    return HeaderScaffold(
      title: "Quản lý bài tập",
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetFilters();
          await controller.loadHomeworks();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         kToolbarHeight - 100,
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
                          onPressed: controller.loadHomeworks,
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
                            Container(
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
                                        width: 300,
                                        child: const Text(
                                          "Tiêu đề",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: const Text(
                                          "Hạn nộp",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: const Text(
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
                                if (controller.homeworks.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(40),
                                    child: const Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            "Không có bài tập nào",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ...controller.homeworks.map((homework) => Container(
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
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                homework.title,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                homework.description.length > 50 
                                                  ? '${homework.description.substring(0, 50)}...'
                                                  : homework.description,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            DateFormat('dd/MM/yyyy HH:mm').format(homework.deadline),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: homework.deadline.isBefore(DateTime.now()) 
                                                ? Colors.red 
                                                : Colors.black87,
                                              fontWeight: homework.deadline.isBefore(DateTime.now()) 
                                                ? FontWeight.bold 
                                                : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: IconButton(
                                            onPressed: () => Get.toNamed('/homework-detail', arguments: {
                                              'homework': homework,
                                            }),
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
      floatingButton: Obx(() {
        final userRole = AuthController.user.value?.role;
        final isTeacherOrAdmin = userRole == 'teacher' || userRole == 'admin';
        
        if (!isTeacherOrAdmin) {
          return const SizedBox.shrink();
        }
        
        return FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateHomeworkDialog(controller: controller),
          ),
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}
