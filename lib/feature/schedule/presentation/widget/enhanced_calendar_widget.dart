import 'package:flutter/material.dart';

class EnhancedCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const EnhancedCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<EnhancedCalendarWidget> createState() => _EnhancedCalendarWidgetState();
}

class _EnhancedCalendarWidgetState extends State<EnhancedCalendarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Enhanced Month/Year Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[50]!,
                    Colors.grey[100]!,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavigationButton(
                    icon: Icons.chevron_left,
                    onPressed: () => _navigateMonth(-1),
                  ),
                  Column(
                    children: [
                      Text(
                        _getMonthText(widget.selectedDate),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.selectedDate.year}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  _buildNavigationButton(
                    icon: Icons.chevron_right,
                    onPressed: () => _navigateMonth(1),
                  ),
                ],
              ),
            ),
            
            // Enhanced Days of week header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700],
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            
            // Enhanced Calendar grid
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildEnhancedCalendarGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: const Color(0xFF3396D3),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedCalendarGrid() {
    final firstDayOfMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Calculate days to show from previous month
    final daysFromPrevMonth = firstWeekday - 1;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysFromPrevMonth));
    
    List<Widget> dayWidgets = [];
    
    for (int i = 0; i < 42; i++) { // 6 weeks * 7 days
      final currentDate = startDate.add(Duration(days: i));
      final isCurrentMonth = currentDate.month == widget.selectedDate.month;
      final isSelected = currentDate.day == widget.selectedDate.day && 
                        currentDate.month == widget.selectedDate.month &&
                        currentDate.year == widget.selectedDate.year;
      final isToday = currentDate.day == DateTime.now().day &&
                     currentDate.month == DateTime.now().month &&
                     currentDate.year == DateTime.now().year;
      
      dayWidgets.add(
        _buildDayCell(currentDate, isCurrentMonth, isSelected, isToday),
      );
    }
    
    return Column(
      children: [
        for (int week = 0; week < 6; week++)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: dayWidgets.sublist(week * 7, (week + 1) * 7),
            ),
          ),
      ],
    );
  }

  Widget _buildDayCell(DateTime currentDate, bool isCurrentMonth, bool isSelected, bool isToday) {
    return Expanded(
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(1),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => widget.onDateSelected(currentDate),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF3396D3)
                    : isToday && !isSelected
                        ? const Color(0xFF3396D3).withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: isToday && !isSelected
                    ? Border.all(
                        color: const Color(0xFF3396D3).withOpacity(0.3),
                        width: 1,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3396D3).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
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
        ),
      ),
    );
  }

  void _navigateMonth(int direction) {
    final newDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month + direction,
    );
    widget.onDateSelected(newDate);
  }

  String _getMonthText(DateTime date) {
    const months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return months[date.month - 1];
  }
}
