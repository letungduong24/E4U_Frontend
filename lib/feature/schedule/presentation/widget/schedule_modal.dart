import 'package:flutter/material.dart';

enum ScheduleModalMode { create, update }

class ScheduleModal extends StatefulWidget {
  final ScheduleModalMode mode;
  final String? initialClassCode;
  final String? initialTime;
  final Function(String classCode, String time) onSave;

  const ScheduleModal({
    super.key,
    required this.mode,
    this.initialClassCode,
    this.initialTime,
    required this.onSave,
  });

  @override
  State<ScheduleModal> createState() => _ScheduleModalState();
}

class _ScheduleModalState extends State<ScheduleModal> {
  late TextEditingController _classCodeController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _classCodeController = TextEditingController(text: widget.initialClassCode ?? '');
    _timeController = TextEditingController(text: widget.initialTime ?? '');
  }

  @override
  void dispose() {
    _classCodeController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.mode == ScheduleModalMode.create ? 'Tạo lịch học' : 'Sửa lịch',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Form content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class Code Field
                  const Text(
                    'Mã lớp',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _classCodeController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập mã lớp',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time Field
                  const Text(
                    'Thời gian',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập thời gian',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      ),
                      readOnly: true,
                      onTap: () => _showDateTimePicker(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Column(
                    children: [
                      // Primary button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3396D3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.mode == ScheduleModalMode.create ? 'Tạo' : 'Sửa',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Cancel button
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Huỷ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
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
    );
  }

  void _showDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((selectedDate) {
      if (selectedDate != null) {
        showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 18, minute: 30),
        ).then((selectedTime) {
          if (selectedTime != null) {
            final endTime = TimeOfDay(
              hour: selectedTime.hour + 2,
              minute: selectedTime.minute,
            );
            setState(() {
              _timeController.text = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.format(context)}-${endTime.format(context)}';
            });
          }
        });
      }
    });
  }

  void _handleSave() {
    final classCode = _classCodeController.text.trim();
    final time = _timeController.text.trim();

    if (classCode.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    widget.onSave(classCode, time);
  }
}
