import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/user-manager/presentation/controller/user_management_controller.dart';

class FilterDialog extends StatefulWidget {
  final UserManagementController controller;

  const FilterDialog({
    super.key,
    required this.controller,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String selectedRole = '';
  String selectedClass = '';

  @override
  void initState() {
    super.initState();
    selectedRole = widget.controller.selectedRole.value;
    selectedClass = widget.controller.selectedClass.value;
    // Ensure classes are loaded when dialog opens
    widget.controller.loadClasses();
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
                  children: [
                    // Header với nút X
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Lọc người dùng",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Form fields với label riêng
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vai trò",
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
                          child: DropdownButtonFormField<String>(
                            value: selectedRole.isEmpty ? null : selectedRole,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Tất cả')),
                              DropdownMenuItem(value: 'student', child: Text('Học viên')),
                              DropdownMenuItem(value: 'teacher', child: Text('Giáo viên')),
                              DropdownMenuItem(value: 'admin', child: Text('Quản trị viên')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value ?? '';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lớp",
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
                            print('FilterDialog: classes.length = ${widget.controller.classes.length}');
                            return DropdownButtonFormField<String>(
                              value: selectedClass.isEmpty ? null : selectedClass,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: [
                                const DropdownMenuItem(value: '', child: Text('Tất cả')),
                                ...widget.controller.classes.map((classItem) {
                                  print('Adding class item: ${classItem['name']} (${classItem['id']})');
                                  return DropdownMenuItem(
                                    value: classItem['id'],
                                    child: Text(classItem['name']),
                                  );
                                }),
                              ],
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value ?? '';
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
                            onPressed: _handleApplyFilter,
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
                              "Áp dụng",
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
                            onPressed: _handleClearFilters,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange.shade600,
                              side: BorderSide(color: Colors.orange.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Xóa lọc",
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

  void _handleApplyFilter() {
    widget.controller.selectedRole.value = selectedRole;
    widget.controller.selectedClass.value = selectedClass;
    widget.controller.loadUsers();
    Navigator.pop(context);
  }

  void _handleClearFilters() {
    setState(() {
      selectedRole = '';
      selectedClass = '';
    });
    widget.controller.clearFilters();
    Navigator.pop(context);
  }
}
