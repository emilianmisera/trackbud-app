import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.date,
          style: CustomTextStyle.regularStyleMedium,
        ),
        SizedBox(
          height: CustomPadding.mediumSpace,
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => Center(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height / 3,
                              child: CupertinoDatePicker(
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() {
                                    _dateTime = newTime;
                                  });
                                },
                                backgroundColor: CustomColor.white,
                                initialDateTime: _dateTime,
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ),
                          ));
                },
                child: CustomShadow(
                  child: Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(
                          horizontal: CustomPadding.defaultSpace),
                      decoration: BoxDecoration(
                        color: CustomColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                              '${_dateTime.day}.${_dateTime.month}.${_dateTime.year}',
                              style:
                                  CustomTextStyle.regularStyleDefault.copyWith(
                                color: CustomColor.bluePrimary,
                              )))),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(60, 60),
                ),),
        
          ],
        ),
      ],
    );
  }
}
