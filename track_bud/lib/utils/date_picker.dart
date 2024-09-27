import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime initialDateTime;
  const DatePicker({super.key, required this.onDateTimeChanged, required this.initialDateTime});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialDateTime;
    debugPrint('This is the saved dateTime: $_dateTime');
  }

  String _getDateText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return 'heute';
    } else if (selectedDate == yesterday) {
      return 'gestern';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime.isAfter(now) ? now : _dateTime,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (context, Widget? child) {
        final defaultColorScheme = Theme.of(context).colorScheme;
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: CustomColor.bluePrimary,
              headerForegroundColor: CustomColor.white,
              backgroundColor: defaultColorScheme.onSurface,
              dayBackgroundColor: WidgetStateProperty.all(defaultColorScheme.onSurface),
              dayOverlayColor: WidgetStateProperty.all(CustomColor.bluePrimary),
              dividerColor: defaultColorScheme.outline,
              surfaceTintColor: Colors.grey[100],
              dayStyle: TextStyle(color: defaultColorScheme.primary, fontWeight: FontWeight.bold),
              todayBackgroundColor: WidgetStateProperty.all(defaultColorScheme.onSurface),
              todayForegroundColor: WidgetStateProperty.all(defaultColorScheme.primary),
              dayForegroundColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return CustomColor.bluePrimary;
                }
                return CustomColor.white;
              }),
              weekdayStyle: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary, fontWeight: FontWeight.w600),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColor.white,
                backgroundColor: CustomColor.bluePrimary,
                padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.mediumSpace),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = DateTime(picked.year, picked.month, picked.day, _dateTime.hour, _dateTime.minute);
      });
      widget.onDateTimeChanged(_dateTime);
    }
  }

  void _updateTime(DateTime newTime) {
    final now = DateTime.now();
    if (_dateTime.year == now.year && _dateTime.month == now.month && _dateTime.day == now.day) {
      // If the selected date is today, ensure the time is not in the future
      if (newTime.isAfter(now)) {
        newTime = now;
      }
    }
    setState(() {
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, newTime.hour, newTime.minute);
    });
    widget.onDateTimeChanged(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppTexts.date, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        const Gap(CustomPadding.mediumSpace),
        Row(
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(Constants.height, Constants.height)),
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(
                    color: defaultColorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _getDateText(_dateTime),
                      style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(CustomPadding.mediumSpace),
            TextButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => Center(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (DateTime newTime) => _updateTime(newTime),
                        backgroundColor: defaultColorScheme.surface,
                        initialDateTime: _dateTime,
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                        maximumDate: DateTime.now(),
                      ),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(Constants.height, Constants.height)),
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(
                    color: defaultColorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
