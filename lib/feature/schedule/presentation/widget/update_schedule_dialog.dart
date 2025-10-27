import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/admin_schedule_controller.dart';

class ScheduleUpdateDialog extends StatefulWidget {
  final String initialClassCode;
  final String initialTime;
  final Function(String time) onSave;

  const ScheduleUpdateDialog({
    super.key,
    required this.initialClassCode,
    required this.initialTime,
    required this.onSave,
  });

  @override
  State<ScheduleUpdateDialog> createState() => _ScheduleUpdateDialogState();
}

class _ScheduleUpdateDialogState extends State<ScheduleUpdateDialog> {
  late final ScrollController _scrollController;
  String selectedPeriod = '08:00-09:00';
  final List<String> periods = [
    '08:00-09:00',
    '09:10-10:10',
    '10:20-11:20',
    '11:30-12:30',
    '12:40-13:40',
    '13:50-14:50',
    '15:00-16:00',
    '16:10-17:10',
    '17:20-18:20',
    '18:30-19:30',
    '19:40-20:40',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Set initial period from initialTime if available
    if (widget.initialTime.isNotEmpty) {
      // Convert "HH:mm - HH:mm" format to "HH:mm-HH:mm" format
      final normalizedTime = widget.initialTime.replaceAll(' - ', '-').replaceAll(' ', '');
      if (periods.contains(normalizedTime)) {
        selectedPeriod = normalizedTime;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminScheduleController>();
    
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 600,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cập nhật lịch học',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
              
                    // Class name label
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Lớp: ${widget.initialClassCode}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
              
                    // Period Field
                    const Text(
                      'Tiết học',
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
                        value: selectedPeriod,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: periods.map((period) => DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPeriod = value ?? '08:00-09:00';
                          });
                        },
                      ),
                    ),
              
                    const SizedBox(height: 24),
              
                    // Action Buttons
                    Column(
                      children: [
                        // Primary button
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value ? null : _handleSave,
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
                              'Cập nhật',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade600,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Hủy',
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
          ),
          // Loading overlay
          Obx(() {
            if (controller.isLoading.value) {
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _handleSave() {
    if (selectedPeriod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn tiết học')),
      );
      return;
    }

    widget.onSave(selectedPeriod);
  }
}
