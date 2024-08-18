import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.editTransaction,
            style: CustomTextStyle.regularStyleMedium),
      ),
      body: SingleChildScrollView(),
    );
  }
}