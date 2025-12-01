import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Wetieko/core/theme/colors.dart';

class BirthdatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<String> onDateChanged;

  const BirthdatePicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<BirthdatePicker> createState() => _BirthdatePickerState();
}

class _BirthdatePickerState extends State<BirthdatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    final month = _getMonthAbbreviation(date.month);
    return '$day $month $year';
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// 📦 Backend'e gönderilecek ISO format (sadece tarih: yyyy-MM-dd)
  String toBackendFormat(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.onboardingBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.light,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1950),
                onDateTimeChanged: (DateTime newDate) {
                  final safeDate = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                  );

                  setState(() {
                    selectedDate = safeDate;
                  });

                  widget.onDateChanged(toBackendFormat(safeDate));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
