import 'package:flutter/material.dart';
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
  List friendList = [];

  void _searchFriend(String query){
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

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
              //SearchField
              SearchTextfield(
                hintText: AppString.search, 
                controller: _searchController,
                onChanged: _searchFriend,
                ),
              SizedBox(height: CustomPadding.defaultSpace,),
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
      ),),
    );
  }
}
