import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/create_group/create_group_sheet.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/searchfield.dart';

class YourGroupsScreen extends StatefulWidget {
  const YourGroupsScreen({super.key});

  @override
  State<YourGroupsScreen> createState() => _YourGroupsScreenState();
}

class _YourGroupsScreenState extends State<YourGroupsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List groupList = [];

  void _searchGroup(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourGroups, style: TextStyles.regularStyleMedium),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(context: context, builder: (context) => CreateGroupSheet()),
            icon: Icon(
              Icons.add,
              color: CustomColor.bluePrimary,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(top: CustomPadding.defaultSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SearchField
              SearchTextfield(
                hintText: AppTexts.search,
                controller: _searchController,
                onChanged: _searchGroup,
              ),
              Gap(CustomPadding.defaultSpace),
              // List of Friends
              /*
              Expanded(
                child: ListView.builder(
                  itemCount: friendList.length,
                  itemBuilder: (context, index){
                    final friend = friendList[index];
                    return FriendCard();
                  },
                  ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
