import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  const DatePicker({Key? key, required this.onDateTimeChanged}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // Initialize with current date and time
  DateTime _dateTime = DateTime.now();

  // Function to get the appropriate date text
  String _getDateText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);

    // Return 'heute' for today, 'gestern' for yesterday, or the date string
    if (selectedDate == today) {
      return 'heute';
    } else if (selectedDate == yesterday) {
      return 'gestern';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      //keep the time when date gets changed
      _dateTime = DateTime(newDate.year, newDate.month, newDate.day, _dateTime.hour, _dateTime.minute);
    });
    widget.onDateTimeChanged(_dateTime);
  }

  void _updateTime(DateTime newTime) {
    setState(() {
      //keep the date when time gets changed
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, newTime.hour, newTime.minute);
    });
    widget.onDateTimeChanged(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date label
        Text(AppTexts.date, style: TextStyles.regularStyleMedium),
        Gap(CustomPadding.mediumSpace),
        Row(
          children: [
            // Date picker button
            TextButton(
              onPressed: () {
                // Show date picker modal
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => Center(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 3,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (DateTime newDate) => _updateDate(newDate),
                        backgroundColor: CustomColor.white,
                        initialDateTime: _dateTime,
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),
                  ),
                );
              },
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
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
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(Constants.height, Constants.height)),
            ),
            Gap(CustomPadding.mediumSpace),
            // Time picker button
            TextButton(
              onPressed: () {
                // Show time picker modal
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
                        backgroundColor: CustomColor.white,
                        initialDateTime: _dateTime,
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                      ),
                    ),
                  ),
                );
              },
              child: CustomShadow(
                child: Container(
                  height: Constants.height,
                  padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                        '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}', // if time is single digit, 0 gets added
                        style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
                  ),
                ),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(Constants.height, Constants.height)),
            ),
          ],
        ),
      ],
    );
  }
}
