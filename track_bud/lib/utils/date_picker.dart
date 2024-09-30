import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

/// Widget for the Date Picker
/// User can select Date and Time
class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime initialDateTime;

  const DatePicker({super.key, required this.onDateTimeChanged, required this.initialDateTime});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _dateTime;
  // current date + time
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialDateTime;
  }

  Future<void> _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorScheme.surface,
          ),
          child: Column(
            children: [
              TableCalendar(
                locale: 'de_DE', // Set the locale to German
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekHeight: 60,
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.now(),
                focusedDay: _dateTime,
                selectedDayPredicate: (day) {
                  return isSameDay(_dateTime, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _dateTime = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, now.hour, now.minute);
                    widget.onDateTimeChanged(_dateTime);
                  });
                  Navigator.pop(context);
                },
                // styling
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: colorScheme.secondary, shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: CustomColor.bluePrimary, shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: colorScheme.primary),
                  // Change the text color of past dates to green
                  defaultTextStyle: TextStyle(color: colorScheme.primary),
                  // Override the text color for past dates
                  disabledTextStyle: TextStyle(color: colorScheme.outline),
                ),
                headerStyle: HeaderStyle(formatButtonVisible: false, titleTextStyle: TextStyle(color: colorScheme.primary)),

                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: CustomColor.bluePrimary),
                  weekendStyle: TextStyle(color: CustomColor.bluePrimary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _dateTime,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, newTime.hour, newTime.minute);
              });
              widget.onDateTimeChanged(_dateTime);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppTexts.date, style: TextStyles.regularStyleMedium.copyWith(color: colorScheme.primary)),
        const Gap(CustomPadding.mediumSpace),
        Row(
          children: [
            // choose Date
            TextButton(
              onPressed: () => _selectDate(context),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(Constants.height, Constants.height)),
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
                  child: Center(
                    child: Text('${_dateTime.day}.${_dateTime.month}.${_dateTime.year}',
                        style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
                  ),
                ),
              ),
            ),
            const Gap(CustomPadding.mediumSpace),
            // choose Time
            TextButton(
              onPressed: () => _selectTime(context),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(Constants.height, Constants.height)),
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
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
