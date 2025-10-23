import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_management_controller.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';

class AssignTeacherDialog extends StatefulWidget {
  final ClassManagementController controller;
  final ClassManagementEntity classItem;

  const AssignTeacherDialog({
    super.key,
    required this.controller,
    required this.classItem,
  });

  @override
  State<AssignTeacherDialog> createState() => _AssignTeacherDialogState();
}

class _AssignTeacherDialogState extends State<AssignTeacherDialog> {
  String selectedTeacherId = '';

  @override
  void initState() {
    super.initState();
    // Always fetch fresh teachers when dialog opens
    _loadTeachers();
    
    // Listen to teachers list changes and reset selection if needed
    ever(widget.controller.teachers, (List<Map<String, dynamic>> teachers) {
      if (selectedTeacherId.isNotEmpty && 
          !teachers.any((teacher) => teacher['id'] == selectedTeacherId)) {
        setState(() {
          selectedTeacherId = '';
        });
      }
    });
  }

  Future<void> _loadTeachers() async {
    try {
      await widget.controller.loadTeachers();
      // Reset selected teacher if it's no longer in the list
      if (selectedTeacherId.isNotEmpty && 
          !widget.controller.teachers.any((teacher) => teacher['id'] == selectedTeacherId)) {
        setState(() {
          selectedTeacherId = '';
        });
      }
    } catch (e) {
      print('Error loading teachers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      "Chọn giáo viên chủ nhiệm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Teacher selection dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Giáo viên",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Obx(() {
                            print('AssignTeacherDialog: teachers.length = ${widget.controller.teachers.length}');
                            
                            if (widget.controller.isLoading.value) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Đang tải danh sách giáo viên...",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (widget.controller.teachers.isEmpty) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Không có giáo viên nào chưa có lớp",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: _loadTeachers,
                                      icon: const Icon(Icons.refresh, size: 16),
                                      label: const Text("Tải lại"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return DropdownButtonFormField<String>(
                              value: selectedTeacherId.isEmpty ? null : selectedTeacherId,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: [
                                const DropdownMenuItem(value: '', child: Text('Chưa chọn giáo viên')),
                                ...widget.controller.teachers.map((teacher) {
                                  print('Adding teacher item: ${teacher['name']} (${teacher['id']})');
                                  return DropdownMenuItem(
                                    value: teacher['id'],
                                    child: Text(teacher['name']),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedTeacherId = value ?? '';
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Buttons theo hàng dọc
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleAssignTeacher,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3396D3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Chọn giáo viên",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade600,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Hủy",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAssignTeacher() async {
    if (selectedTeacherId.isNotEmpty) {
      try {
        await widget.controller.setHomeroomTeacher(
          widget.classItem.id,
          selectedTeacherId,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}