import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppString.accAdjustments,
            style: CustomTextStyle.regularStyleMedium,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add, color: CustomColor.bluePrimary, size: 30,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
        // spacing between content and screen
        padding: EdgeInsets.only(
            top: CustomPadding.defaultSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchTextfield(hintText: AppString.search, controller: _searchController),
              SizedBox(height: CustomPadding.defaultSpace,),
            ],
          ),
      ),),
    );
  }
}
