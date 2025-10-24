import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_student_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_students_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';
import 'package:intl/intl.dart';

class ClassStudentProfileDialog extends StatelessWidget {
  final ClassStudentEntity student;

  const ClassStudentProfileDialog({
    super.key,
    required this.student,
  });

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
                    // Header
                    const Text(
                      "Chi tiết học sinh",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Avatar + Basic info
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/default_avatar.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                student.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Học sinh",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Detail info section
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
                                  student.email,
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
                                "Lớp học:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                student.className,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Mã lớp:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                student.classCode,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ngày nhập học:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('dd/MM/yyyy').format(student.enrolledAt),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ghi chú:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                student.enrollmentNotes.isNotEmpty ? student.enrollmentNotes : "Không có ghi chú",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.pop(context); // Đóng dialog hiện tại
                                        _showRemoveStudentConfirmation(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: const Text(
                                          "Xóa khỏi lớp",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.pop(context); // Đóng dialog hiện tại
                                        _showTransferClassDialog(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: const Text(
                                          "Chuyển lớp",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _showRemoveStudentConfirmation(BuildContext context) {
    final controller = Get.find<ClassStudentsController>();
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: "học sinh khỏi lớp",
        deleteFunction: () async {
          Navigator.pop(context); // Close confirmation dialog
          await controller.removeStudentFromClass(student.id);
          Navigator.pop(context); // Close profile dialog after API call
        },
        controller: controller,
      ),
    );
  }

  void _showTransferClassDialog(BuildContext context) {
    // TODO: Implement transfer class dialog
    print('Transfer student ${student.id} to another class');
    Navigator.pop(context); // Close profile dialog
  }
}
