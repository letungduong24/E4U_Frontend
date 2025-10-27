import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Month/Year Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Navigate to previous month
                      final newDate = DateTime(
                        selectedDate.year,
                        selectedDate.month - 1,
                      );
                      onDateSelected(newDate);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF3396D3),
                    ),
                    iconSize: 20,
                  ),
                ),
                Text(
                  _getMonthYearText(selectedDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Navigate to next month
                      final newDate = DateTime(
                        selectedDate.year,
                        selectedDate.month + 1,
                      );
                      onDateSelected(newDate);
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF3396D3),
                    ),
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Days of week header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // Calendar grid
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildCalendarGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Calculate days to show from previous month
    final daysFromPrevMonth = firstWeekday - 1;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysFromPrevMonth));
    
    List<Widget> dayWidgets = [];
    
    for (int i = 0; i < 42; i++) { // 6 weeks * 7 days
      final currentDate = startDate.add(Duration(days: i));
      final isCurrentMonth = currentDate.month == selectedDate.month;
      final isSelected = currentDate.day == selectedDate.day && 
                        currentDate.month == selectedDate.month &&
                        currentDate.year == selectedDate.year;
      final isToday = currentDate.day == DateTime.now().day &&
                     currentDate.month == DateTime.now().month &&
                     currentDate.year == DateTime.now().year;
      
      dayWidgets.add(
        GestureDetector(
          onTap: () => onDateSelected(currentDate),
          child: Container(
            height: 44,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF3396D3)
                  : isToday && !isSelected
                      ? const Color(0xFF3396D3).withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              border: isToday && !isSelected
                  ? Border.all(
                      color: const Color(0xFF3396D3).withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '${currentDate.day}',
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : isCurrentMonth 
                          ? isToday
                              ? const Color(0xFF3396D3)
                              : Colors.black87
                          : Colors.grey[400],
                  fontWeight: isSelected || isToday 
                      ? FontWeight.w600 
                      : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: [
        for (int week = 0; week < 6; week++)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: dayWidgets.sublist(week * 7, (week + 1) * 7),
            ),
          ),
      ],
    );
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

