import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_assets.dart';

/// Bottom Sheet Date Picker 1:1 sesuai 10daritanggal_popup.jpeg
class BjbDatePickerBottomSheet extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const BjbDatePickerBottomSheet({
    super.key,
    this.title = 'Atur tanggal mulai',
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    String title = 'Atur tanggal mulai',
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final now = DateTime.now();
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BjbDatePickerBottomSheet(
        title: title,
        initialDate: initialDate ?? now,
        firstDate: firstDate ?? DateTime(now.year - 2),
        lastDate: lastDate ?? DateTime(now.year + 1),
      ),
    );
  }

  @override
  State<BjbDatePickerBottomSheet> createState() =>
      _BjbDatePickerBottomSheetState();
}

class _BjbDatePickerBottomSheetState extends State<BjbDatePickerBottomSheet> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthYearString = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(_displayedMonth);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Judul + Icon Tutup
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF64748B),
                    size: 22,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Kalender Container Krem / Off-white (1:1 sesuai 10daritanggal_popup.jpeg)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F0),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                children: [
                  // Navigasi Bulan: < September 2026 >
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF334155),
                        ),
                        onPressed: _previousMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        monthYearString,
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF334155),
                        ),
                        onPressed: _nextMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Header Nama Hari: Sen Sel Rab Kam Jum Sab Min
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DayNameCell('Sen'),
                      _DayNameCell('Sel'),
                      _DayNameCell('Rab'),
                      _DayNameCell('Kam'),
                      _DayNameCell('Jum'),
                      _DayNameCell('Sab'),
                      _DayNameCell('Min'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Grid Tanggal
                  _buildDaysGrid(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Kuning "Simpan"
            GestureDetector(
              onTap: () => Navigator.of(context).pop(_selectedDate),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDB913),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFDB913).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstWeekday = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    ).weekday; // 1 = Monday

    // Previous month filler
    final prevMonthDays = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      0,
    ).day;
    final leadingDays = firstWeekday - 1;

    final List<Widget> dayWidgets = [];

    // Leading days (greyed out)
    for (int i = leadingDays - 1; i >= 0; i--) {
      dayWidgets.add(
        _DateCell(
          dayNumber: prevMonthDays - i,
          isCurrentMonth: false,
          isSelected: false,
          onTap: () {},
        ),
      );
    }

    // Days in current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      final isSelected =
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      dayWidgets.add(
        _DateCell(
          dayNumber: day,
          isCurrentMonth: true,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      );
    }

    // Trailing days to fill rows (multiples of 7)
    final totalCells = (dayWidgets.length / 7).ceil() * 7;
    int nextMonthDay = 1;
    while (dayWidgets.length < totalCells) {
      dayWidgets.add(
        _DateCell(
          dayNumber: nextMonthDay++,
          isCurrentMonth: false,
          isSelected: false,
          onTap: () {},
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: dayWidgets,
    );
  }
}

class _DayNameCell extends StatelessWidget {
  final String name;
  const _DayNameCell(this.name);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final int dayNumber;
  final bool isCurrentMonth;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateCell({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFF0083C9), width: 1.8)
              : null,
          color: isSelected ? const Color(0xFFE2F3FD) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            '$dayNumber',
            style: TextStyle(
              fontFamily: AppAssets.fontFamily,
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: !isCurrentMonth
                  ? const Color(0xFFCBD5E1)
                  : isSelected
                  ? const Color(0xFF00588A)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
}
